; kernel.asm - nucleo do sistema operacional
; Copyright (c)(tm)(R) XinForInfoLabs 2025 - NullCyan/TheGBO
bits 16
org 0x9000

jmp kernelMain

;---dados
msg: db "Kernel carregado com sucesso!", 13, 10, 0
xinforinfolaLogo:
    db '+---------------------------------------+',13,10
    db '|              /\  /\                   |',13,10
    db '|             /  \/  \                  |',13,10
    db '|  xx     /  =| @  @ |=      _-         |',13,10
    db '|    \   /   =|  __  |=     / /         |',13,10
    db '|     \ /      ------______/ /          |',13,10
    db '|      x        |           Xinfo       |',13,10
    db '|     / \       | | |____| | | rinfola  |',13,10
    db '|    /   \      /_/_/    /_/_/          |',13,10
    db '|   /     xxXINFORINFOLA OS (TM)        |',13,10, 
    db '+---------------------------------------+',13,10, 0

cmdPrompt: db 13, 10, "[xinfOS]->", 0
cmdLen: db 0
;---


printStr:
	xor ax, ax
	mov ds, ax
	push si
	pusha ;push all
	mov ah, 0x0e
.iter: ; al = [SI], SI++
	lodsb ; uma forma mais fácil de imprimir strings que descobri recentemente
	cmp al, 0
	je .end
	int 0x10
	jmp .iter
.end:
	popa
	pop si
	ret

printChar:
    push ax
    mov ah, 0x0e
    int 0x10
    pop ax
    ret

;--- main
kernelMain:
;-- mensagem inicial
    mov si, msg
    call printStr
    mov si, xinforinfolaLogo
    call printStr

