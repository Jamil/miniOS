.org 0x5000
.global main

# Function addresses 
.equ newLine, 0x1704
.equ loadSDBlock, 0x1480
.equ clearScreen, 0x1648

# Internal definitions
.equ SD_ADDRESS, 0x00800000
.equ OS_BASE, 0x10000 ##0x10000
.equ SIZE_SHELL, 10        # Size of shell (x512b)

### BOOTLOADER
#   Loads the shell from the SD card, then jumps to it.

main:

# Initialization
##call clearScreen
movia sp, 0x00200000  # Reset stack pointer (we don't need anything the BIOS was using,
                      # and it should be this anyway)

# Load shell from SD card into main memory
loadShell:
  movi r16, 1               # Iterator
  movi r17, SIZE_SHELL      # Max
load_loop:  
  bgt r16, r17, end_load    # Done loading
  movi r18, 512             # r18 will be destination (on disk) address 
  mul r18, r18, r16         # iterator * blocksize
  
  movia r20, OS_BASE
  
  add r19, r18, r20     # Address in main memory    
  subi r19,r19, 512


  movi r4, SD_ADDRESS       # Disk address
  mov r5, r18               # Address of block on disk 
  mov r6, r19               # Address of block in MM (to copy to)
  call loadSDBlock

  addi r16, r16, 1          # Increment iterator 
  br load_loop
  
end_load:
jmp r20

  
