;stack e entrada de teclado

bits 16
org 0x7c00

cli            ; desativa interrupções
xor ax, ax     ; zera o registrador AX
mov ss, ax     ; zera o segmento da stack
mov sp, 0x7e00 ; coloca 0x7e00 como o início do ponteiro da stack
; -------------- eu inicialmente havia colocado 0x7c00, mas há um risco da stack sobrescrever dados do programa,
; -------------- desta forma, desloquei em 0x200 (512 bytes), exatamente o tamanho do setor de boot 
sti            ; reativa interrupções

jmp main ;pula para a rotina principal

;-=-=-=[IMPORTANTE. TIPO. *MUITO* IMPORTANTE. MESMO.]=-=-=-
; BX, BL E BH SÃO O MESMO REGISTRADOR
; O MESMO VALE PARA QUALQUER UM, TIPO AX, AL E AH
; (R)X, (R)L, (R)H 
; ---
; apesar de serem o mesmo registrador, os valores são diferentes, estamos trabalhando em 16 bits
; utilizando o exemplo do registrador B
; vamos supor que eu coloque o número "0xB1FE" em BX
; BX => o registrador inteiro, todos os 16 bits (B1FE)
; BH => os 8 bits "altos"  (B1)
; BL => os 8 bits "baixos" (FE)

;
putc:
	push cx      ;salva o valor do registrador cx na memória stack
	mov ah, 0x0e ;opcode de video
	mov bh, 0x00 ;página de vídeo 0
	mov al, cl   ;coloca o caractere guardado em cl em al
	int 0x10     ; imprime o caractere guardado em al (previamente em cl)
	pop cx       ;restaura valor anterior de cx
	ret

main:
	;limpar a tela caso a placa mãe ou o fabricante coloque algum texto
	mov ah, 0x00
	mov al, 0x02   ; modo texto 80x25
	int 0x10

	; imprimir caractere '>'
	mov cl, '>'
	call putc

readLoop:
	mov cl, 0
	mov ah, 0    ; Opcode de ler do teclado
	int 0x16     ; Chamada para a BIOS performar tal operação

	cmp al, 0    ; evita que um caractere nulo seja impresso.
	je readLoop

	mov cl, al   ; coloca a tecla lida (vai para AL) em cl, parametro da função putc
	call putc    ; chama putc!

	jmp readLoop

jmp $        ; 'Pausa' a execução do programa


times 510 - ($ - $$) db 0
dw 0xAA55