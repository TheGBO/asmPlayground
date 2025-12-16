bits 16
org 0x7e00

jmp kernelMain

;---dados
msg: db "Kernel carregado com sucesso!", 13, 10, 0
xinforinfolaLogo:
    db '                                  ',13,10
    db '            /\  /\                ',13,10
    db '           /  \/  \               ',13,10
    db 'xx     /  =| @  @ |=      _-      ',13,10
    db '  \   /   =|  __  |=     / /      ',13,10
    db '   \ /      ------______/ /       ',13,10
    db '    x        |           X|info   ',13,10
    db '   / \       | | |____| | |rinfola',13,10
    db '  /   \      /_/_/    /_/_/       ',13,10
    db ' /     xxXINFORINFOLA OS (TM)     ',13,10, 0
;---

;---funções
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
;---

;--- main
kernelMain:
    mov si, msg
    call printStr
    mov si, xinforinfolaLogo
    call printStr
    jmp $
