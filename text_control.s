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
  muli r9, r6, 128        # r9 will represent the address to print to
  addi r9, r9, r4         # 


