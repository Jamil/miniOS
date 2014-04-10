.org 0x00130000
.equ newLine, 0x170c

.global main

main:
  
  subi sp, sp, 4
  stw ra, (sp)
  
  movia r20, str
  movi r21, 0x31    # ensure string is 1 to start
  stb r21, (r20)
  
  movia r4, str
  call newLine
  movia r4, str
  call newLine
  
  movi r4, 5
  call fib
  
  ldw ra, (sp)
  addi sp, sp, 4
  
done_main:
  ret

fib:
  movi r16, 1   # fib[k-2]
  movi r17, 1   # fib[k-1]
  mov r19, r4
fib_loop:
  bgt r17, r19, done
  add r18, r16, r17     # fib[k]
  
  movia r20, str
  addi r21, r18, 0x30   # ascii value of number
  stb r21, (r20)        # store in first char of str
  
  subi sp, sp, 4
  stw ra, (sp)
  
  mov r4, r20
  call newLine
  
  ldw ra, (sp)
  addi sp, sp, 4

  mov r16, r17
  mov r17, r18
  
  br fib_loop
done:
  ret
  
str: 
  .asciz "1"
