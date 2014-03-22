### Text Control
##  Print string or line to screen

.section .data
.equ CHAR_BUFFER, 0x09000000

.section .text

# Function: printChar
# Prints character to screen at location (x, y)
# r4 = character to print
# r5 = x coordinate
# r6 = y coordinate

printChar:
  movia r8, CHAR_BUFFER
  muli  r9, r6, 128             # r9 will represent the address to print to; here we get the y offset
  add   r9, r9, r5              # add that to the x offset to get the relative address
  add   r9, r9, r8              # get absolute address to print to
  stwio r4, (r9)                # store ASCII value of character in character buffer
  ret

# Function: updateLine
# Updates line at row y to string str
# r4 = pointer to str
# r5 = row to print to

updateLine:
  # Save return address
  subi sp, sp, 4
  stw ra, (sp)

  # Save callee-save registers
  subi sp, sp, 20
  stw  r16, -16(sp)
  stw  r17, -12(sp)
  stw  r18, -8(sp)
  stw  r19, -4(sp)
  stw  r20, (sp)

  mov r16, r5               # Row to print to
  mov r17, r0               # Column to print to
  mov r18, r4               # Mutable pointer to string  

string_iter:                   # Iterate through string, print each character
  ldw  r19, (r18)              # Load character into register
  beq  r19, r0, done           # Return from function when null-terminating character reached
  mov  r4, r19                 # Character to print
  mov  r5, r17                 # Column (x-coord)
  mov  r6, r16                 # Row (y-coord)
  call printChar
  
  addi r18, r18, 1             # Increment pointer
  addi r17, r17, 1             # Increment column number

  br string_iter

done:
  # Restore callee-save registers
  ldw r20, (sp)
  ldw r19, -4(sp)
  ldw r18, -8(sp)
  ldw r17, -12(sp)
  ldw r16, -16(sp)
  addi sp, sp, 12

  # Restore return address
  ldw ra, (sp)
  addi sp, sp, 4

  ret





