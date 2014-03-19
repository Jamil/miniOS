.include "nios_macros.h"

.section .data

.equ SRAM_ADDRESS 0x0807FFFF
.equ LED_GREEN_ADDRESS 0x10000010

bootloader_location: 
.skip 512

.section .text

# BIOS Operations
#   1. Ensure SD Card / memory is inserted and can be read
#   2. Check for boot signature 0xaa55
#   3. Load Master Boot Record (MBR) from disk into memory
#   4. Jump to location where MBR is loaded
#   If none found, display an error on VGA

# STEP 1
# Ensuring SD Card / memory is inserted

# (skip this section while SRAM is the disk)

# STEP 2
# Check for boot signature

checkSignature:

                                        # Load MBR into main memory
    movia r4, SRAM_ADDRESS              # Disk Address
    mov   r5, zero                      # Destination address (on disk)
    movia r6, bootloader_location       # Target address (in Main Memory)
    call loadBytes
    
    movia r17, bootloader_location
    ldh r16, 510(r17)                   # Load MBR Signature (bytes 510 and 511)
    
    cmpeqi r17, r16, 0xaa55             # Check if boot signature is AA55
    beq r17, r0, no_boot_sector
    bne r17, r0, success
    
no_boot_sector:
    movi r17, 1                         # Set debug bit on LEDs
    movia r18, LED_GREEN_ADDRESS         
    stwio r17, (r18)
    
    br no_boot_sector

success:
    jmp bootloader_location
    
    
    
    
    
    
    




