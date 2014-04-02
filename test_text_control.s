### Text Control Tests

.global main

.section .data

.equ ADDR_VGA, 0x08000000
.equ ADDR_CHAR, 0x09000000

str:
  .asciz "Good morning, Dr. Chandra. This is Hal. I am ready for my first lesson."
str2:
  .asciz "Just what do you think you're doing, Dave?"
unichar:
  .asciz "A"
  
.section .text

main:
  call VGA_INIT
  
  movi sp, 0x3000
  call clearScreen
  
  movi r4, 1
  call resetLine
  
  movi r16, 10		# Repeat until...
  movi r17, 0		  # Iterator
  
print_loop:
  bgt r17, r16, end
  
  movia r19, unichar
  ldb r18, (r19)
  addi r18, r18, 1
  stw r18, (r19)
  
  movia r4, unichar
  call newLine
  
  addi r17, r17, 1
  br print_loop
  
end:
  br end
