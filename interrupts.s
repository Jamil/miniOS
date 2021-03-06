# Include nios_macros.s to workaround a bug in the movia pseudo-instruction.


.section .exceptions, "ax"

myISR:

   
   
##   movia et, ADDR_GREENLEDS
##   stwio r10,(et)
##	movia et, ADDR_REDLEDS
##    stwio r11,(et)

    ##saves regiistorers into stack
	addi sp,sp,-28
	stw r16,0(sp)
	stw r17,4(sp)
	stw r18,8(sp)
	stw r19,12(sp)
	stw r2,16(sp)
	stw r4,20(sp)
	stw ra, 24(sp)
		

	## checks if the interreupt is from the key board	
	rdctl et,ctl4
	             #0 7643210   
	andi r17,et,0x80
	bne r17,r0, call_ps2
	    
	br GOTOEND
	
call_ps2:
	
    	
	
    ##call the keyboard control function
	call ps2controller
	
    movia r4,buffer_read
    ldw   r4,(r4)
    call replaceLine  
  

	
notload_test:	
#######################
	
	
	br GOTOEND
	
GOTOEND:
 
   
 
	ldw r16,0(sp)
	ldw r17,4(sp)
	ldw r18,8(sp)
	ldw r19,12(sp)
	ldw r2,16(sp)
	ldw r4,20(sp)
	ldw ra, 24(sp)
	
	
    addi sp,sp,28

getout2:
	
  subi ea,ea,4
  eret
  
 .data
str_test:
  .asciz "Hello world"

 .text

.equ PS2, 0x10000100 
.equ ADDR_REDLEDS, 0x10000000	
.equ ADDR_GREENLEDS, 0x10000010

##buffer register
.equ shift_press, 0x00120000      ##boolean that show if shift is been pressed, 1 if yes, 0 of no
.equ buffer_control, 0x00120010   ##size of the string buffer 
.equ buffer_read, 0x00120020   ##pointer address that must start to read
.equ buffer_f0_press, 0x00120030   ##pointer address that must start to read
.equ buffer_start, 0x00120100  ##actual start adrees of the buffer
.equ buffer_show_size, 60
.equ parser_address, 0x101d0

.global ps2_initialize

ps2_initialize:

GET_INTERRUPTS:
 	
  addi sp,sp,-4
  stw ra, (sp)
  
	movia r8,PS2       ##enabling interutps in ps2
	movi r9,1
	stwio r9,4(r8)

              #876543210	
	movia r8,0b010000000    ##inable in the interrupt   in ienable 
	wrctl ctl3,r8
	
	movi r8,1              ##enable pie
	wrctl ctl0,r8
	
	movia r8,shift_press      ##initialise shift to  unpress
	stw r0,(r8)
	
	movia r8,buffer_f0_press      ##initialise shift to  unpress
	stw r0,(r8)
	
	movia r8,buffer_control  ##initialise the size to 0
	stw r0,(r8)
	
	movia r8,buffer_start    ##initialise the first character to null
	stw r0,(r8)
	
	movia r9,buffer_read     ##initialise the read character to the start character
	stw r8,(r9)

	
	####initialse buffer controls
	
 
  stw ra,(sp)
  addi sp,sp,4

	
  ret

