### Text Control Tests

.global main

.section .data

.equ ADDR_VGA, 0x08000000
.equ ADDR_CHAR, 0x09000000

str:
  .asciz "Good morning, Dr. Chandra. This is Hal. I am ready for my first lesson."
str2:
  .asciz "Just what do you think you're doing, Dave?"
  
.section .text

main:
  movi sp, 0x3000
  call clearScreen
  movi r4, 0x41
  movi r5, 0
  movi r6, 1
  call printChar
  
  movi r4, 2
  call resetLine
  
  movi r16, 10		# Repeat until...
  movi r17, 0		# Iterator
  
print_loop:
  bgt r17, r16, end
  
  movia r4, str
  call newLine
  
  movia r4, str2
  call newLine
  
  addi r17, r17, 1
  br print_loop
  
end:
  br end
