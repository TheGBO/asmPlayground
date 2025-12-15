
; Real mode, arquitetura 16 bits.
bits 16

; Quando a BIOS carrega o código, ele é carregado nesse endereço de memória
org 0x7c00

;----código customizado vai aqui--------

mov ah, 0x0e ; Especifica modo de vídeo no registrador ah
mov al, 'X'  ; Especifica dado a ser mostrado na tela
int 0x10     ; Chamada para a BIOS performar tal operação
jmp $        ; 'Pausa' a execução do programa

;----código customizado termina aqui----

;Preenche o espaço vazio com 510 bytes nulos
times 510 - ($ - $$) db 0

; Número 'mágico' (boot signature) para dar o boot
dw 0xAA55