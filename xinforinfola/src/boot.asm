; boot.asm - o bootloader principal para carregar o kernel
; Copyright (c)(tm)(R) XinForInfoLabs 2025 - NullCyan/TheGBO
bits 16
org 0x7c00
jmp 0:start ; Força o CS a ser 0, garantindo que o offset 0x7c00 esteja correto

start:
	cli 
	xor ax, ax
	mov es, ax
	mov ds, ax
	mov ss, ax
	mov bp, 0x9C00
	mov sp, bp
	mov bx,0x9000
	sti

jmp bootloaderMain
; --- Definições de variáveis
bootDisk: db 0
bootloaderMsg: db "Carregando Xinforinfola OS (TM)...", 13, 10, 0
diskErrMsg: db "Leitura de disco falhou :(", 13, 10, "...iniciando programa TMNMC (tua mae na minha cama kkkj eh mole)", 13, 10, 0
kernelLoadMsg: db "Efetuando leitura de kernel para a memoria...", 13, 10, 0
; ---

; ===

; --- Definições de funções
clStr:
	mov ah, 0x00
	mov al, 0x03
	int 0x10
	ret


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
; ---

bootloaderMain:
	call clStr

	mov si, bootloaderMsg
	call printStr

	;reset de disco (compatibilidade)
	mov [bootDisk], dl ;salva o numero do disco passado pela bios
	mov ah, 0 ; função 0x0 : reset disk drive
	mov dl, [bootDisk] 
	int 0x13
	jc .readDiskERR
	;fim do reset

	xor ax, ax
	mov es, ax
	mov bx, 0x9000

	mov ah, 2          
	mov al, 2 ;2 setores (1kb)          
	mov ch, 0          
	mov cl, 2          
	mov dh, 0          
	mov dl, [bootDisk] 
	int 0x13
	jnc .readDiskOK
	jc .readDiskERR
	jmp $

.readDiskOK:
	mov si, kernelLoadMsg
	call printStr
	jmp 0x9000

.readDiskERR:
	mov si, diskErrMsg
	call printStr
	jmp $

times 510 - ($ - $$) db 0
dw 0xAA55