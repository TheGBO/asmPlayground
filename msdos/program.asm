;[bits 16]
;[org 0x100]
use16
org 0x100

; interrupts
dosCall equ 0x21
;opcodes
printStr equ 0x09
readChar equ 0x01
terminate equ 0x4c00

start:
    mov ah, printStr
    mov dx, msg
    int dosCall

    mov ah, printStr
    mov dx, msg
    int dosCall

printLoop:
    mov ah, printStr
    mov dx, 32  
    int dosCall


    mov ax, terminate
    int dosCall

;dados
char: db 0x20, "$"
msg: db "Hello world", 13, 10, "$"