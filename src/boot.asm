bits 16
org 0x7c00

cli 
xor ax, ax
mov es, ax
mov ds, ax
mov ss, ax
mov bp, 0x8000
mov sp, bp
mov bx, 0x7e00
sti

jmp bootloaderMain
; --- Definições de variáveis
bootDisk: db 0
bootloaderMsg: db "Carregando Xinforinfola OS (TM)...", 13, 10, 0
diskErrMsg: db "Leitura de disco falhou :(", 13, 10, 0
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
	ret
; ---

bootloaderMain:
	call clStr

	mov si, bootloaderMsg
	call printStr

	mov [bootDisk], dl
	mov ah, 2          
	mov al, 1          
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
	jmp 0x7e00

.readDiskERR:
	mov si, diskErrMsg
	call printStr
	jmp $

times 510 - ($ - $$) db 0
dw 0xAA55