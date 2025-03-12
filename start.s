.SECT .TEXT
  MOV SI, (x)

  MOV AX, SI
  MUL AX
  MOV BX, AX
  MUL BX
  MOV CX, 2
  MUL CX
  ADD SI, AX

  MOV AX, BX
  MOV BX, 3
  MUL BX
  SUB SI, AX

  SUB SI, 5

  MOV (res), SI
.SECT .DATA
x:  .WORD 7

.SECT .BSS
res:  .SPACE 2
