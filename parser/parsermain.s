.section .data

.equ SRAM_ADDRESS, 0x08050000
.equ LED_GREEN_ADDRESS, 0x10000010
.equ SD_CONTROL_ADDRESS, 0x00800000

strings_pointer:
pt_os_1:           .word str_os_1                             #0
pt_os_2:           .word str_os_2                             #1
pt_arrow:          .word str_arrow							  #2
pt_pwd:            .word str_pwd                              #3
pt_execute:        .word str_execute                          #4
pt_ls:             .word str_ls                               #5
pt_cd:             .word str_cd                               #6
pt_pwd_print:   .word str_pwd_print                           #7
pt_executing_program:   .word str_executing_program           #8
pt_ls_print:   .word str_ls_print                             #9
pt_cd_print:    .word str_cd_print                             #10


strings:
str_os_1:           .string ">> Starting OS"
str_os_2:           .string ">> Shell kernel running"
str_arrow:             .string ">>"
str_pwd:            .string "pwd"
str_execute:        .string "execute"
str_ls:             .string "ls"
str_cd:             .string "cd"
str_pwd_print:   .string "you are home"
str_executing_program:   .string "executing program "
str_ls_print:   .string "There is nothing here"
str_cd_print:   .string "goin to: "


.section .text

.global main

main:

  call parser