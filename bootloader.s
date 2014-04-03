.org 0x5000
.global main
.equ newLine, 0x16d8

main:
  movi r4, str
  call newLine
end:
  br end
  
str:
  .asciz "!! This operation was loaded from SRAM."
  
.skip 8