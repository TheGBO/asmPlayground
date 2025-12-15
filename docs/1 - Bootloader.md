Nesta anotação, irei pontuar pontos chave de como criar um bootloader em assembly de 16 bits que faz uso da MBR (Master Boot Record) para carregar um código customizado.

## Ferramentas necessárias:
- NASM - Um assembler para compilar o código
- Um editor de texto qualquer - NeoVIM, VSCode, NANO...
- Um emulador - de preferência o QEMU

```assembly
; Nome do arquivo: boot.asm

; Real mode, arquitetura 16 bits.
bits 16

; Quando a BIOS carrega o código, ele é carregado nesse endereço de memória
org 0x7c00.

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
```

OK, mas como compila isso? 
```bash
nasm -f bin boot.asm -o boot.bin
```
> O comando acima faz uso do NASM para transformar o código em um arquivo binário

Para rodar, é relativamente simples:
```bash
qemu-system-i386 boot.bin
```

## Como enfiar numa imagem de disco .img

1. Criar uma img vazia: 
	 - enfiar 10 megabytes zeros num arquivo chamado `disk.img`
```bash
dd if=/dev/zero of=disk.img bs=1M count=10
```

2. Usar a imagem
	- `conv=notrunc` É importante para preservar o resto do arquivo e seu respectivo tamanho.
```bash
# criar uma imagem de disco
dd if=boot.bin of=disk.img bs=512 conv=notrunc

# colocar a imagem num pendrive. CUIDADO! zona de escaralhamento.
lsblk #identificar o pendrive

#no meu caso é /dev/sdb , desmonto todas partições.
sudo umount /dev/sdb*

#SEMPRE escreva no DISPOSITIVO (/dev/sdb) nunca na partição (/dev/sdb1)
sudo dd if=disk.img of=/dev/sdb bs=512 conv=notrunc status=progress

# Fazer com que as alterações sejam aplicadas definitivamente
sudo sync
```

# Seria esse o fim? NÃO XD. É o começo.
[[2 - Strings e caracteres em assembly]]
