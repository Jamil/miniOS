# Include nios_macros.s to workaround a bug in the movia pseudo-instruction.
.include "nios_macros.s"


  
.section .data

.align 2

##the definitions of the ps2 codes.


#prefix code

ps2_char:
ps2_Alphabte:
.byte 0x1C,0x32,0x21,0x23,0x24,0x2B,0x34,0x33,0x43,0x3B,0x42,0x4B,0x3A,0x31,0x44,0x4D,0x15,0x2D,0x1B,0x2C,0x3C,0x2A,0x1D,0x22,0x35,0x1A
######  A    b   c    d    e    f     g   h     i    j   k     m   n
######  0     1   2   3   4     5    6    7     8    

number:
.byte 0x45,0x16,0x1E,0x26,0x25,0x2E,0x36,0x3D,0x3E,0x46

ps2_arrowkeys:
.byte 0x75,0x6B,0x72,0x74
#UP_ARROW=75
#left ARROW=6B
#down ARROW=72
#rigth ARROW=74


#special characters
ps2_enter:
.byte 0x5A
ps2_space:
.byte 0x29
ps2_backspace:
.byte 0x66
ps2_comma:
.byte 0x41
ps2_period:
.byte 0x49		
ps2_slash:
.byte 0x4A
	
##this are the definition of the ascii characters	
ascii_char:
ascii_lower:
.byte 0x61,0x62,0x63,0x64,0x65,0x66,0x67,0x68,0x69,0x6A,0x6B,0x6C,0x6D,0x6E,0x6F,0x70,0x71,0x72,0x73,0x74,0x75,0x76,0x77,0x78,0x79,0x7A


ascii_number:
.byte 0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39

ascii_arrowkeys:
.byte 0x81,0x82,0x83,0x84
#UP_ARROW=81
#left ARROW=82
#down ARROW=83
#rigth ARROW=84

#special characters
ascii_enter:
.byte 0x5A
ascii_space:
.byte 0x29
ascii_backspace:
.byte 0x66
ascii_comma:
.byte 0x41
ascii_period:
.byte 0x49		
ascii_slash:
.byte 0x4A

##the addres of the ps2controller

.text

.equ PS2_ADDRESS, 0x10000100 
.equ STOP_CHAR, 0xF0  ##this code is used after a key is released followd by the key code ex: F0,XX
.equ FILL_CHAR, 0xE0  ##this code is used before the arrows keys ex, E0,XX or if is released EO,FO,XX
.equ SHIFT, 0x12      ##this is the code for shift
.equ BACKSPACE, 0x8      ##this is the code for shift

##buffer register
.equ shift_press, 0x00120000      ##boolean that show if shift is been pressed, 1 if yes, 0 of no
.equ buffer_control, 0x00120010   ##size of the string buffer 
.equ buffer_read, 0x00120020   ##pointer address that must start to read
.equ buffer_start, 0x00120100  ##actual start adrees of the buffer
.equ buffer_show_size, 60

.global ps2controller

###
###
##parameters non
##returns
##r2=> character send by keyboard, null if nothing
##r3=> if the value in r2 is valid
###
###


##state of shift character=> 0 for not press, 1 for pressed


ps2controller:
  addi r11,r11,0x100

  
  ##saving register to stack
  addi sp,sp,-28
  stw r16,0(sp)
  stw r17,4(sp)
  stw r18,8(sp)
  stw r19,12(sp)
  stw r20,16(sp)
  stw r21,20(sp)
  stw ra, 24(sp)  
 
 ##loading the first character from the ps2 buffer

load_again: 
  movia r16,PS2_ADDRESS

  ldwio r19,0(r16)
  srli r21,r19,16
  beq r21,r0,finish
  
  andi r19,r19,0xFF
  
  
  
  movia r18,FILL_CHAR    ##if EO was in the begganing go back to load_agian to load the next character
  beq r18,r19,load_again
  
  movia r18,STOP_CHAR    ##if FO was in the begganing load one more character and ret
  beq r18,r19,load_real_ascii
  
check_shift_down:               ##check if shift was pressed, must load a new char
 	
  movi r16,SHIFT          
  bne r19,r16,load_again
    
  movi r16,1           
  movia r18,shift_press           ##set shift_press equal to zero because shift has been pressed
  stw r16,(r18)
  
  br load_again 
  
  
  
load_real_ascii:  
  movia r16,PS2_ADDRESS
  
  mov r15,r19
  
  
  addi r11,r11,0x1000
  
  ldwio r19,0(r16)
 
  srli r21,r19,16
   
  beq r21,r0,finish
  
  andi r19,r19,0xFF
  
 

  movia r18,SHIFT    ##if FO was in the begganing load one more character and ret
  beq r18,r19,shift_up
  
  movi r15,0x44

  movia r18,BACKSPACE    ##if FO was in the begganing load one more character and ret
  beq r18,r19,back_space_pressed
  
  movi r15,0xcc
  
  movia r16,ps2_char    ##load the address with the array of the values of ps2 controller  
  
  add r17,r0,r0        
  addi r17,r17,-1 
  
  movi r15,0xee
  
loop_check_ps2:         ##loop until the value that it euals to one of the ps2 codes in thee array
   
  addi r17,r17,1       
  add r20,r16,r17        
  ldb r18,0(r20)        ##loading loads ps2 code from array
  andi r18,r18,0xFF     ##mask the code.
  
  movi r20,48
  
  addi r11,r11,0x4000
  
  add r15,r19,r0
  movi r15,0xaa
 
  bge r17,r20, load_again   ##checks if iterator is greater than 48(maxsize of array), if greater a non key was press
  
  addi r11,r11,0x4000
  
  bne r19,r18, loop_check_ps2  ## the code is equal to the ps2 code in the array
  

  
  movia r16,ascii_char
  add r16,r16,r17              ##loading corresponding ASCII value to r21
  ldb r21,0(r16)
  andi r21,r21,0xFF  
  
  movia r18,shift_press
  ldw r18,(r18)
  
  beq r18,r0,save_bufffer            ##check if shift was pressed during  the call, branch if is not
  movi r16,26
  bge r17,r16,save_bufffer          ##check if char is a letter
 
change_uppercase:             ##changes char to uppercase  by subtracting 0x20 to the ascci value
  movia r16,-0x20
  add r21,r21,r16
  br save_bufffer

shift_up:                   ##change shift_press to ZERO because shift was release
  movia r18,shift_press           
  stw r0,(r18)
  br load_again 
 

save_bufffer:
  movia r18,0x10000
  add r11,r18,r11

  movia r18, buffer_control  ##size of the string buffer 
  movia r16, buffer_start    ##start memory of string buffer
  
  ldw r19,(r18)              ##loads size of buffer

  add r16,r16,r19           ##adds size of buffer to adress
  
  stw r21,(r16)              ##stores new char in null character
  
  addi r16,r16,1 
  
  stw r0,(r16)              ##places new null terminating character
  
  addi r19,r19,1             ##adds one to the size of buffer and stores it
  
  stw r19,(r18)
  
  movi r16,buffer_show_size   ##check if string is greater than 60
  
  sub r19,r19,r16
  
  blt r19,r0,no_read_offset
  br read_offset

  
back_space_pressed:
  movia r18, buffer_control  ##size of the string buffer 
  movia r16, buffer_start    ##start memory of string buffer
  
  ldw r19,(r18)              ##loads size of buffer

  beq r19,r0,no_read_offset  ##if size of string is zero does nothing
  
  add r16,r16,r19           ##adds size of buffer to adress
  subi r16,r16,1            ##replaces last character for null termanitng char
  
  stw r0,(r16)              ##places new null terminating character
  
  subi r19,r19,1             ##adds one to the size of buffer and stores it
  
  stw r19,(r18)
  
  movi r16,buffer_show_size   ##check if string is greater than 60
  
  sub r19,r19,r16
  
  blt r19,r0,no_read_offset
  br read_offset
  
  
  
read_offset:
  movia r16, buffer_start    ##creaters an offest for the read pointer
  add r16,r16,r19
  
  movia r18,buffer_read
  stw r16,(r18)
  br load_again
  
  
no_read_offset:  
  movia r16, buffer_start    ##set the read pointer equal to the start of the buffer
  
  movia r18,buffer_read
  stw r16,(r18)
  
  br load_again
  
finish:

  ldw r16,0(sp)
  ldw r17,4(sp)
  ldw r18,8(sp)
  ldw r19,12(sp)
  ldw r20,16(sp)
  ldw r21,20(sp)
  ldw ra, 24(sp)  
  addi sp,sp,28
  
  ret

.end
