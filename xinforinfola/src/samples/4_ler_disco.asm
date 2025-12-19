; como usar mais do que 512 bytes!
bits 16
org 0x7c00

cli            ; desativa interrupções
xor ax, ax     ; zera o registrador AX
mov es, ax     ; zera ES
mov ds, ax     ; zera o segmento de dados

;-----------------------------------------------------------------------------------------------+
mov ss, ax                  ; coloca o segmento de stack no endereço 0x0000                     | 
mov bp, 0x8000              ; coloca 0x8000 como o início do ponteiro da stack                  |
mov sp, bp                  ; SP=BP = 0x8000                                     				|
; 							os endereços são (endereço físico = segmento * 16 + deslocamento)   |
;							Sendo assim, a stack fica em 0x0000:0x8000, longe do bootloader     |
;                           deslocada em 32kb.                                                  |
;																								|
;                           o registrador estável que define a base da stack é o BP, o SP muda  |
;							conforme o uso.                                                     |
;-----------------------------------------------------------------------------------------------|
;                           REVISÃO                                                             |
;                           SS = stack segment;                                                 |
;                           BP = base pointer (por convenção), na realidade a stack é SS:SP     |
;							SP = stack pointer (ponteiro da stack);								|
;							ES = es, registrador de dados auxiliar usado pela bios				|
;							BX = Registrador de uso geral, no entanto, a bios usa como base		|
;							     pra muita coisa, por exemplo, dados endereçados como ES:BX		|
;																								|
;                           neste contexto, representado pelos registradores : SS * 16 + SP     |
mov bx, 0x7e00              ; coloca o buffer de leitura do disco (ES:BX) em 0000:7E00          |
sti                         ; ativa interrupções                                                |
;-----------------------------------------------------------------------------------------------+

; pular para a rotina principal
jmp main

bootDisk: db 0 ; definir variável que guarda a id do dispositivo de armazenamento

main:
	; observação -> o nomeDoRotulo é apenas o endereço de memória dele
	;               o valor guardado, é na verdade, [nomeDoRotulo]
	mov [bootDisk], dl ; a bios coloca o disco de boot em dl, irei salvar essa variável

	mov ah, 2          ; opcode para ler do disco
	mov al, 1          ; o número de setores (512b) a serem lidos
	mov ch, 0          ; o número do cilindro para ser lido
	mov cl, 2          ; o setor a ser lido (no caso, o segundo setor)
	mov dh, 0          ; o numero da cabeça do disco a ser lido 
	mov dl, [bootDisk] ; para ter certeza
	int 0x13           ; efetua leitura de disco
    jnc ok             ;carry flag = 0 leitura efetuada com sucesso
    jc diskErr
	jmp $
ok:
	mov ah, 0x0e ; modo de vídeo da bios
	mov al, [0x7e00] ; lê o que tá escrito naquele endereço de memória
	int 0x10 ; imprime o que tá escrito naquele endereço de memória e foi carregado via leitura de disco
    jmp $
diskErr:
    mov ah, 0x0e
    mov al, ':'
    int 0x10
    mov al, '('
    int 0x10
    jmp $

times 510 - ($ - $$) db 0
dw 0xAA55

; enfia um monte de letra A para tentar ler
times 512 db 'A'