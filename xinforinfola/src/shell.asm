; shell.asm - shell do sistema operacional
; Copyright (c)(tm)(R) XinForInfoLabs 2025 - NullCyan/TheGBO
org 0xA000
;16 CHAR     "_-_-_-_-_-_-_-_-"
fileName: db "SYS.SHELL.XINF16", 0
fileSectors: db 1
.printPrompt:
    mov si, cmdPrompt
    call printStr
    mov byte [cmdLen], 0
.shellLoop:
    mov ah, 0
    int 0x16

    cmp al, 0x08
    je .handleBackspace

    cmp al, 0x0d
    je .handleEnter

    call printChar
    inc byte [cmdLen]
    jmp .shellLoop
.handleBackspace:
    cmp byte [cmdLen], 0
    je .shellLoop
    dec byte [cmdLen]
    mov al, 0x08
    call printChar
    mov al, ' '
    call printChar
    mov al, 0x08
    call printChar
    jmp .shellLoop
.handleEnter:
    mov al, 13
    call printChar
    mov al, 10
    call printChar
    ;processar o comando aqui depois...
    jmp .printPrompt
    jmp $