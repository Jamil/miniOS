.section .data

.equ SRAM_ADDRESS, 0x08050000
.equ LED_GREEN_ADDRESS, 0x10000010
.equ SD_CONTROL_ADDRESS, 0x00800000

str_boot:         .asciz ">> Starting boot process."
str_sd:           .asciz ">> Looking for SD Card..."
str_notfound:     .asciz ">> Could not find SD Card. I'll try the SRAM now."
str_sdfound:      .asciz ">> Found SD Card."
str_bootsearch:   .asciz ">> Checking Master Boot Record (MBR) for signature 0xaa55."
str_bootfail:     .asciz ">> No boot record found on disk. Aborting."
str_loadsucc:     .asciz ">> MBR Found. Exiting BIOS and passing control to bootloader."

bootloader_space:   
  .skip 1000   

.section .text

.global main

main:

  call parser