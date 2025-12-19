bits 16
org 0x7c00

mov bx, msg ;Registrador de uso geral chamado bx -> recebe o endereço de memoria do inicio da mensagem

printLoop:
	;---
	mov ah, 0x0e ;Modo de vídeo
	mov bh, 0x00 ;página de vídeo 0 (página de vídeo é tipo uma tela virtual ou algo assim, a 0 é a visivel por padrão.)
	mov al, [bx] ;Derefence: pegar o conteudo de bx e colocar no al, é como fazer "*ponteiro" em C 	
	cmp byte al, 0 ;String terminada em caractere nulo
	je halt ;caso o byte seja de fato 0, finalize a execução do programa 	
	int 0x10 ;Chamar função da BIOS que imprime caracteres.
	;---
	inc bx ;incrementa o valor de bx, ou seja, vá para o próximo endereço na mensagem.
	;---
	jne printLoop ;caso contrário -> continue até chegar no 0


halt:
	jmp $
	msg db "Ola, mundo!", 0 ;acentos "n<?>o" funcionam quando se trata disso, mas eles aparecem nos comentÁrios de cÓdigo tranqÜilamente: çáção.

times 510 - ($ - $$) db 0 
dw 0xAA55
