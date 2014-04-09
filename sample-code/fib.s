.org 0x00130000
.equ newLine, ???

main:
  movi r4, 5
  call fib
  br main

fib:
  movi r16, 1   # fib[k-2]
  movi r17, 1   # fib[k-1]
  mov r19, r4
fib_loop:
  bgt r17, r19, done
  addi r18, r16, r17    # fib[k]
  
  movi r20, str
  addi r21, r18, 30     # ascii value of number
  stb r21, (r20)        # store in first char of str
  call newLine

  addi r16, r16, 1
  addi r17, r17, 1
  
  br fib_loop
done:
  br done
  
 str: 
  .asciz "1"
