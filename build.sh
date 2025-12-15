#!/bin/bash
#build.sh : é chato pra um zaralho ter que digitar cada um desses comandos por vez
# é justamente por isso que eu criei esse script

# compilar o código
nasm -f bin src/boot.asm -o bin/boot.bin
# criar a imagem de disco 
dd if=/dev/zero of=bin/disk.img bs=1M count=10
dd if=bin/boot.bin of=bin/disk.img bs=512 conv=notrunc

#rodar o código
qemu-system-i386 bin/boot.bin
