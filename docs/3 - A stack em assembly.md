A stack, ou "pilha" em português é uma região da memória utilizada para se comportar como a estrutura de dados com o mesmo nome.

Neste contexto, é utilizada (automaticamente) pelo processador para funções como:
- guardar endereços de retorno de funções (via `call` e `ret`)
- fazer um 'backup' de registradores utilizando `push` e  `pop` 

No exemplo anterior, caso o que eu havia feito de fato funcionou (xD funciona na minha máquina pelo menos), foi pura sorte ou gambiarra, pois apesar de eu ter utilizado `call` e `ret` , não inicializei a stack, o que poderia ter causado comportamento ~~fudido~~ imprevisível.

Para inicializar a stack, é necessário fazer o seguinte no início do programa:

```nasm
cli          ; desativa interrupções
xor ax, ax   ; zera o registrador AX
mov ss, ax   ; zera o segmento da stack
mov sp, 0x7c00 ; coloca 0x7c00 como o ponteiro
sti          ; reativa interrupções
```
