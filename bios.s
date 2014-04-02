.section .data

.equ SRAM_ADDRESS, 0x0807FFFF
.equ LED_GREEN_ADDRESS, 0x10000010
.equ SD_CONTROL_ADDRESS, 0x20000000

bootloader_location: 
.skip 512

str_boot:         .asciz "Good morning, Dr. Chandra. This is HAL. I'm ready for my first lesson."
str_sd:           .asciz "Looking for SD Card. Timeout in 10 seconds."
str_notfound:     .asciz "Could not find SD Card. I'll try the SRAM now."
str_bootsearch:   .asciz "Disk found. Checking Master Boot Record (MBR) for signature 0xaa55."
str_bootfail:     .asciz "No boot record found on disk. Aborting."
str_bootsuc:      .asciz "MBR found. Loading bootloader into memory."
str_loadfail:     .asciz "Could not load bootloader into main memory. Aborting."
str_loadsucc:     .asciz "Exiting BIOS and passing control to bootloader."

.section .text

# BIOS Operations
#   1. Ensure SD Card / memory is inserted and can be read
#   2. Check for boot signature 0xaa55
#   3. Load Master Boot Record (MBR) from disk into memory
#   4. Jump to location where MBR is loaded
#   If none found, display an error on VGA

.global main

main:

# STEP 1
# Ensuring SD Card / memory is inserted

checkSDExists:                         # Check to see whether bootloader should be from SRAM or SD
  movia r18, 50000000                 # One second (50M clock cycles)
  muli r18, r18, 10                   # Ten seconds
  movi r19, 0                         # Iterator
  movia r16, SD_CONTROL_ADDRESS
check_SD_loop:
  bgt r19, r18, checkSRAM             # After timeout, check the SRAM 
  ldw r17, 564(r16)                   # Load Auxiliary Status Register
  andi r17, r17, 0b10                 # Mask to see if SD Card present
  bne r17, r0, checkSDReady           # If the SD card is inserted, check to see if it's ready.
  addi r19, r19, 1
  br check_SD_loop

checkSRAM:
loadBoot:
  movia r4, SRAM_ADDRESS              # Disk Address
  mov   r5, zero                      # Destination address (on disk)
  movia r6, bootloader_location       # Target address (in Main Memory)
  call loadSRAMBlock
  br checkSignature

checkSDReady:
  movia r18, LED_GREEN_ADDRESS        # Set debug bits to show that we're using the SD Card
  movi r19, 0b010
  stwio r19, (r18)

  ldw r18, 568(r16)                   # Check Response R1 Register
  addi r18, r18, 0x1000000            # Check to see if SD Card is initialized
  bne r18, r0, checkReady

  movia r4, SD_CONTROL_ADDRESS        # Disk Address
  mov   r5, zero                      # Destination address (on SD Card)
  movia r6, bootloader_location       # Target address (in Main Memory)
  call loadSDBlock
  br checkSignature

# STEP 2
# Check for boot signature
  
checkSignature:
  movia r17, bootloader_location
  ldhu r16, 510(r17)                  # Load MBR Signature (bytes 510 and 511)
    
	movia r18, 0xaa55
	andi r18, r18, 0xFFFF
  cmpeq r17, r16, r18		              # Check if boot signature is AA55
  beq r17, r0, no_boot_sector
  bne r17, r0, success
    
no_boot_sector:
  movi r17, 0b0100                     # Set debug bit on LEDs
  movia r18, LED_GREEN_ADDRESS         
  stwio r17, (r18)
    
  br no_boot_sector

success:
	movi r17, 0b01                    # Set debug bit on LEDs
  movia r18, LED_GREEN_ADDRESS
  stwio r17, (r18)

  movia r17, bootloader_location
  jmp r17
    
    
    
    
    
    
    




