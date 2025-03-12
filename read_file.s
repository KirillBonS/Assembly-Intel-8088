.MODEL SMALL
.STACK 100H

.DATA
    FILENAME DB "task1.dat", 0  ; Имя файла (нуль-терминированная строка)
    BUF DW 1                   ; Буфер для записи двухбайтового числа
    MSG_ERROR DB "Error creating or writing to file!", 0DH, 0AH, "$"
    FILE_HANDLE DW ?
    NUM_TO_WRITE DW 10         ; Количество чисел для записи
    ACCESS_RIGHTS DW 0600H      ; Права доступа (чтение и запись для владельца)

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; 1. Создание файла

    MOV AH, 3CH          ; Функция DOS: CREATE
    MOV CX, ACCESS_RIGHTS ; Права доступа (0600H)
    LEA DX, FILENAME    ; Адрес имени файла
    INT 21H

    JC CREATE_ERROR    ; Переход к обработке ошибки, если CF=1

    MOV FILE_HANDLE, AX  ; Сохранить дескриптор файла
  
    ; 2. Запись чисел в файл (цикл)

    MOV CX, NUM_TO_WRITE  ; Количество итераций цикла

WRITE_LOOP:
    ; Запись текущего значения из буфера в файл
    MOV BX, FILE_HANDLE ; Дескриптор файла
    MOV AH, 40H          ; Функция DOS: WRITE
    MOV DX, OFFSET BUF  ; Адрес буфера данных
    MOV CX, 2           ; Количество байт для записи (2 байта для DW)
    INT 21H

    JC WRITE_ERROR    ; Переход к обработке ошибки, если CF=1

    ; Увеличение значения в буфере
    INC BUF

    LOOP WRITE_LOOP       ; Декремент CX и переход к началу цикла, если CX != 0


    ; 3. Закрытие файла

    MOV AH, 3EH          ; Функция DOS: CLOSE
    MOV BX, FILE_HANDLE ; Дескриптор файла
    INT 21H

    ; Выход из программы
    MOV AH, 4CH
    INT 21H

CREATE_ERROR:
    LEA DX, MSG_ERROR
    MOV AH, 09H
    INT 21H
    JMP EXIT

WRITE_ERROR:
    LEA DX, MSG_ERROR
    MOV AH, 09H
    INT 21H

EXIT:
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
