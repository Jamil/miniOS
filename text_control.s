### Text Control
##  Print string or line to screen

.equ VGA_BUFFER, 0x08000000
.equ CHAR_BUFFER, 0x09000000
.equ TEMP_STORE, 0x00110000

.global printChar
.global updateLine
.global clearScreen
.global resetLine
.global newLine
.global VGA_INIT

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
  stbio r4, (r9)                # store ASCII value of character in character buffer
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
  stw  r16, 16(sp)
  stw  r17, 12(sp)
  stw  r18, 8(sp)
  stw  r19, 4(sp)
  stw  r20, (sp)

  mov r16, r5               # Row to print to
  mov r17, r0               # Column to print to
  mov r18, r4               # Mutable pointer to string  

string_iter:                   # Iterate through string, print each character
  ldb  r19, (r18)              # Load character into register
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
  ldw r19, 4(sp)
  ldw r18, 8(sp)
  ldw r17, 12(sp)
  ldw r16, 16(sp)
  addi sp, sp, 20

  # Restore return address
  ldw ra, (sp)
  addi sp, sp, 4
  ret
  
# Function: resetLine
# Sets line to no characters (black)
# r4 = line to reset

resetLine:
  # Save return address
  subi sp, sp, 4
  stw ra, (sp)
  
  movi r8, 0          # Iterator
  movi r9, 128        # Maximum Value
  mov r10, r4         # y-offset
  movia r11, CHAR_BUFFER
resetLineLoop:
  bgt r8, r9, endreset
  movi r4, 0x00
  mov r5, r8
  mov r6, r10
  
  # Save caller-save registers
  subi sp, sp, 20
  stw r4, (sp)
  stw r8, 4(sp)
  stw r9, 8(sp)
  stw r10, 12(sp)
  stw r11, 16(sp)
  
  call printChar
  
  # Restore caller-save registers
  ldw r4, (sp)
  ldw r8, 4(sp)
  ldw r9, 8(sp)
  ldw r10, 12(sp)
  ldw r11, 16(sp)
  addi sp, sp, 20
  
  addi r8, r8, 1
  br resetLineLoop
  
endreset:
  # Restore return address
  ldw ra, (sp)
  addi sp, sp, 4
  ret
  
# Function: clearScreen
# Sets the entire row to black

clearScreen:
  movia r14, VGA_BUFFER
  movia r15, CHAR_BUFFER
  movi r6, 0              # Iterator
clearLoop:
  bgt r11, r15, endclear
  add r11, r6, r14        # r11 is destination pixel
  movi r12, 0x00          # Set to black
  sthio r12, (r11)
  addi r6, r6, 2          # Increment by 4
  br clearLoop 
endclear:
  ret 


###### QUEUE OPERATIONS ######

## newLine
##  Inserts a new line into the VGA queue, scrolling up if necessary.

## queueLen
##  Returns the number of lines in the queue

## replaceLine
##  Replaces the latest line in the queue

# Function: replaceLine
# r4 => Pointer to string 

replaceLine:
  movi r14, 59              # Maximum row number
  
  stw ra, (sp)
  call queueLen             # Check length of queue 
  ldw ra, (sp)  
  
  mov r5, r2                # Set second arg to line number
                            # (first argument already stored in r4)
  call updateLine
  ret 

# Function: VGA_INIT
# Initializes VGA queue memory

VGA_INIT:
  movia r14, TEMP_STORE
  movi r15, 1
  stw r15, (r14)
  ret
 
# Function: queueLen
# r2 <= Length of queue 

queueLen:
  movia r14, TEMP_STORE     # Load temporary storage block address
  ldw r2, (r14)             # Load contents of block
  ret 

# newLine
# Inserts a new line into the VGA queue, scrolling up if necessary.  
# r4 => Pointer to string to print

newLine:
  movi r14, 59              # Maximum row number
  
  stw ra, (sp)
  call queueLen             # Check length of queue 
  ldw ra, (sp)  
  
  bge r2, r14, shiftLines   # If screen is full, scroll instead of appending
  blt r2, r14, appendLine   # Otherwise, just append the line to the end

shiftLines:
  movi r8, CHAR_BUFFER 
  movi r9, 128               # Starting point of iterator (destination location)
  add r9, r9, r8
  movi r10, 256              # Starting point of iterator (source location)
  add r10, r10, r8
  movi r11, 128
  muli r11, r11, 59         # Limit (for destination pointer)
  add r11, r11, r8
copy_iter:
  bgt r10, r11, done_cpy    # Branch when reach limit
  ldb r12, (r10)            # Load byte from source location
  stb r12, (r9)             # Store byte in destination 
  addi r10, r10, 1
  addi r9, r9, 1
  br copy_iter
done_cpy:
  movi r2, 59
  br appendLine
  
appendLine:
  mov r14, r4               # Move the pointer to the string so it doesn't get clobbered
  mov r5, r2                # Row to print to 
  addi r5, r5, 1            # Offset by 1
  
  subi sp, sp, 4            # Save return address 
  stw ra, (sp)
  
  call updateLine 

  ldw ra, (sp)              # Restore return address 
  addi sp, sp, 4
  
  movi r14, TEMP_STORE
  addi r2, r2, 1
  stw r2, (r14)
  
  ret

