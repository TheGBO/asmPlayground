Nesta parte, irei construir por cima do programa anterior, o [[1 - Bootloader]], o objetivo agora é mostrar texto na tela, e curiosamente, eu já havia começado a "fundação disso"

```nasm
; [...]
mov ah, 0x0e ; Especifica modo de vídeo no registrador ah
mov al, 'X'  ; Especifica dado a ser mostrado na tela
int 0x10     ; Chamada para a BIOS performar tal operação
; [...]
```

O pedaço de código acima é o ponto chave, já sabemos como imprimir um único caractere, mas e um texto inteiro? A maneira mais óbvia, aparentemente seria a seguinte:
```nasm
; [...]
mov ah, 0x0e ; Especifica modo de vídeo no registrador ah
mov al, 'B'
int 0x10    
mov al, 'e'
int 0x10   
mov al, 'm'
int 0x10
mov al, '-'
int 0x10
mov al, 'v'
int 0x10
mov al, 'i'
int 0x10
mov al, 'n'
int 0x10
mov al, 'd'
int 0x10
mov al, 'o'
int 0x10
; [...]
```
Mas note como isso é inconveniente, ainda que funcional, não seria interessante se pudéssemos simplesmente fazer algo como `mov al, 'Bem-Vindo'`? Bem, pior que não. Digo... seria interessante, mas não é possível dessa forma, porque só é possível imprimir um byte por vez. Mas há sim uma forma mais inteligente.

Antes de tudo, é necessário salientar o conceito de um "rótulo" em assembly, abaixo está um código que imprime a letra X 4 vezes, idiota, porém introduz alguns conceitos chave: `rótulos e condicionais` 

```asm
bits 16  
org 0x7c00  
  
; --- é assim que se pula para um rótulo
; --- neste caso, ignorando o código dentro de 'putch'
jmp main  

; --- é assim que se define um rótulo
; --- em tese, poderia ser qualquer nome, mas putch soa legal e faz um pouco de
; ------ sentido: PUT CHARacter, colocar caractere em inglês.
putch:  
 mov ah, 0x0e  
 mov al, 'X'  
 int 0x10  
 ret ; --- significa 'RETornar', quando um rótulo é chamado, essa instrução orienta o processador a voltar e prosseguir com a próxima instrução
  
; o rótulo da função principal, imprime apenas um 'XXXX'
main:          
 call putch ;o call é parecido com o jmp, mas ele respeita o ret.
 call putch ;com o ret respeitado, a próxima função é chamada
 call putch ; e assim sucessivamente...
 call putch ;a identação não faz diferença em assembly
  
jmp $ ;o cifrão representa o endereço de memória atual, o que faz o programa ficar preso em "fazer nada".
; --- No final das contas, rótulos são apenas endereços de memória.
  
times 510 - ($ - $$) db 0    
dw 0xAA55
```

Agora sim, podemos fazer o que queríamos
```nasm
bits 16  
org 0x7c00  
  
mov bx, msg ;Registrador de uso geral chamado bx -> recebe o endereço de memoria do inicio da mensagem  
  
printLoop:  
 ;---  
 mov ah, 0x0e ;Modo de vídeo  
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
```

[[3 - A stack em assembly]]