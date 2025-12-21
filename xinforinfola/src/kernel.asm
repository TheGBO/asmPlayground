; kernel.asm - nucleo do sistema operacional
; Copyright (c)(tm)(R) XinForInfoLabs 2025 - NullCyan/TheGBO
bits 16

KERNEL_BASE equ 0x9000 ;endereço base do kernel

org KERNEL_BASE 


jmp kernelMain

;---dados
;string literal:
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
invalidOpcodeMsg: db "[PANICO DO KERNEL]::OPCODE INVALIDO", 13, 10

;variaveis
cmdLen: db 0
;---

installSysCallHandler:
    cli ;desativa interrupções
    push ds

    xor ax, ax ;zera AX
    mov ds, ax ; DS = 0x0000 (endereço da Interrupt Vector Table)

    ;         0x1f => código da syscall!!!!
    mov ax, cs
    mov word [0x1f*4], syscallHandler ;endereço da instrução de lidar com syscalls ou algo assim sei lá xd
    mov word [0x1f*4+2], ax ;segmento do kernel 
    
    pop ds
    sti ;reativa interrupções
    ret

; 0x1F = syscall
; AX = opcode
; DX = parametro
syscallHandler:
    push ds ;preserva segmento de dados
    pusha

    mov bx, ax ;salva o opcode passado em AX em BX

    mov ax, cs ;guarda code segment em ax
    mov ds, ax ;data segment = code segment

    ; 0x0001 - print logo
    cmp bx, 0x0001
    je _logoPrint
    ; 0x0002 - print proposito geral (string precisa terminar em 0)
    cmp bx, 0x0002
    je _gpPrint

    ;fim da rotina principal do handler
    mov si, invalidOpcodeMsg
    call printStr
    jmp _syscallHandlerEnd
_logoPrint:
    mov si, xinforinfolaLogo
    call printStr
    jmp _syscallHandlerEnd
_gpPrint:
    mov si, dx
    call printStr
    jmp _syscallHandlerEnd
_syscallHandlerEnd:
    popa
    pop ds
    iret

printStr:
    push ds ;preserva ds (segmento de dados)
    push si ;preserva si (coisinha de iterar string)
    pusha   ;preserva todos registradores de propósito geral

	mov ax, cs ;curent segment vai em ax
	mov ds, ax ;ax vai em data segment
	mov ah, 0x0e ;opcode modo vídeo
_iter: ; al = [SI], SI++
	lodsb ; uma forma mais fácil de imprimir strings que descobri recentemente
	cmp al, 0
	je _end
	int 0x10 ;imprimir caractere
	jmp _iter
_end:
	popa
	pop si
    pop ds
	ret
printChar:
    push ax
    mov ah, 0x0e
    int 0x10
    pop ax
    ret

;--- main
kernelMain:
    cli
    mov ax, cs
    mov ds, ax
    mov es, ax
    sti
;-- instala serviços básicos
    call installSysCallHandler
;-- mensagem inicial
    mov si, msg
    call printStr

    ; imprime a logo xinforinfola
    mov ax, 0x0001
    int 0x1f

    ;imprime uma mensagem
    mov ax, 0x0002
    mov dx, hwmsg
    
    int 0x1f
jmp $

hwmsg: db "Hello, World!", 0