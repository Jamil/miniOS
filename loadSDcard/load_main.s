.section .data

.equ SRAM_ADDRESS, 0x08050000
.equ LED_GREEN_ADDRESS, 0x10000010
.equ SD_CONTROL_ADDRESS, 0x00800000
.equ OS_ADDRESS_MAIN, 0x2000
.equ OS_ADDRESS_SD_CARD, 0 ##0x0
.equ NUMBER_OF_CLUSTER, 10   ##must change from boot loader to the os

str_boot:         .asciz ">> Starting boot process."
str_sd:           .asciz ">> Looking for SD Card..."
str_notfound:     .asciz ">> Could not find SD Card. I'll try the SRAM now."
str_sdfound:      .asciz ">> Found SD Card."
str_bootsearch:   .asciz ">> Checking Master Boot Record (MBR) for signature 0xaa55."
str_bootfail:     .asciz ">> No boot record found on disk. Aborting."
str_loadsucc:     .asciz ">> MBR Found. Exiting BIOS and passing control to bootloader."

bootloader_space:   
  .skip 512   

.section .text

# BIOS Operations
#   1. Ensure SD Card / memory is inserted and can be read
#   2. Check for boot signature 0xaa55
#   3. Load Master Boot Record (MBR) from disk into memory
#   4. Jump to location where MBR is loaded
#   If none found, display an error on VGA

.global main

main:

checkSDExists:                        # Check to see whether bootloader should be from SRAM or SD
  movia r18, 500000                   # .5 M clock cycles
  movi r19, 0                         # Iterator
  movia r16, SD_CONTROL_ADDRESS
check_SD_loop:
  bgt r19, r18, finish             # After timeout, check the SRAM 
  ldw r17, 564(r16)                   # Load Auxiliary Status Register
  andi r17, r17, 0x2                  # Mask to see if SD Card present
  bne r17, r0, load_SDcard           # If the SD card is inserted, check to see if it's ready.
  addi r19, r19, 1
  br check_SD_loop

load_SDcard:
 
  movia r4, SD_CONTROL_ADDRESS
  mov r16,r0
  movi r17, NUMBER_OF_CLUSTER
  movia r5, OS_ADDRESS_SD_CARD
  movia r6, OS_ADDRESS_MAIN 
  
  
loop:  

  call loadSDBlock
  addi r5,r5,512
  addi r6,r6,512
  addi r16,r16,1
  bne  r16,r17, loop
  
finish:
  br finish 
  
 
 
