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
  # Save registers r4 through r6
  subi sp, sp, 12
  stw  r4, -8(sp)
  stw  r5, -4(sp)
  stw  r6, (sp)
  
  # Save callee-save registers
  subi sp, sp 20
  stw  r16, -16(sp)
  stw  r17, -12(sp)
  stw  r18, -8(sp)
  stw  r19, -4(sp)
  stw  r20, (sp)

  mov   r16, r5
  muli  r16, r16, 128            # Relative base address of line
  movia r17, CHAR_BUFFER        
  add   r5, r5, r17              # Absolute base address of line

string_iter:                  # Iterate through string, print each character
  





