# Include nios_macros.s to workaround a bug in the movia pseudo-instruction.
.include "nios_macros.s"

.section .exceptions, "ax"

myISR:
    

	
	
	addi sp,sp,-28
	stw r16,0(sp)
	stw r17,4(sp)
	stw r18,8(sp)
	stw r19,12(sp)
	stw r2,16(sp)
	stw r4,20(sp)
	stw ra, 24(sp)
	
	movia r16, TIMER
	stwio r0, 4(r16)
	
	
	rdctl et,ctl4
	             #07643210   
	andi r17,et,0b01000000
	beq 17,r0, call_ps2
    br GOTOEND
	
call_ps2:
    mov r8,r4
	call ps2controller
	mov r8,r3
	mov r9,r2
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

  
.section .text
.equ PS2, 0x10000100 
.equ ADDR_REDLEDS, 0x10000000	
.equ ADDR_GREENLEDS, 0x10000010


.global main


main:


GET_INTERRUPTS:
	movia r8,PS2
	movi r9,1
	stwio r9,4(r8)
	
	movia r8,0b01000000          
	wrctl ctl3,r8
	movi r8,1
	wrctl ctl0,r8
	
	mov r8,r0
	mov r9,r0
	
	movia r16,ADDR_GREENLEDS
	movia r17,ADDR_REDLEDS
	
loop_main:
   
    stwio r8,(ADDR_GREENLEDS)
	stwio r9,(ADDR_REDLEDS)
	
	br loop_main
	
.end