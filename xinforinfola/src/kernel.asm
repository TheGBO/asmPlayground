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
; ------+-----------------+----------------+
; Reg.  | MODO ENTRADA    |  MODO SAÍDA    |
; AX    | opcode          | Código de erro | (0 = ok, 1 = erro) 
; BX    | parametro 1     |       ?        |
; CX    | parametro 2     |       ?        |
; DX    | parametro 3     |       ?        |  
; ------------------------+-----------------
syscallHandler:
    push ds ;preserva segmento de dados
    pusha

    push cs
    pop ds     ; DS = CS

    ; 0x1 - print logo
    cmp ax, 0x1
    je _logoPrint

    ; 0x2 - print proposito geral (string precisa terminar em 0)
    cmp ax, 0x2
    je _sysPrint

    ; 0x3 - print unico caractere
    cmp ax, 0x3
    je _sysPrintChar

    ; 0x4 - limpa tela
    cmp ax, 0x4
    je _sysCls

    ; 0x05 - posição do cursor
    cmp ax, 0x5
    je _sysCursorPos

    ;fim da rotina principal do handler
    mov si, invalidOpcodeMsg
    call printStr
    mov ax, 1
    jmp _syscallHandlerEnd
;0x1
;sem parametros
_logoPrint:
    mov si, xinforinfolaLogo
    call printStr
    xor ax, ax; sucesso
    jmp _syscallHandlerEnd
;0x2
;BX = endereço de memoria da string
_sysPrint:
    mov si, bx
    call printStr
    xor ax, ax
    jmp _syscallHandlerEnd
;0x3
;BL = caractere a ser impresso
_sysPrintChar:
    mov ah, 0x0e
    mov al, bl
    int 0x10
    xor ax, ax
    jmp _syscallHandlerEnd
;0x4
_sysCls:
	mov ah, 0x00
	mov al, 0x03
	int 0x10
    xor ax, ax
    jmp _syscallHandlerEnd
;0x5 
; BX = cursor X
; CX = cursor Y
_sysCursorPos:
    mov ah, 0x02
    mov dl, bl
    mov dh, cl
    mov bh, 0
    int 0x10
    xor ax, ax
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
    ; imprime a logo xinforinfola
    mov ax, 0x1
    int 0x1f

    mov ax, 0x02
    mov bx, msg
    int 0x1f

jmp $
