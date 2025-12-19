#!/bin/bash
#build.sh : é chato pra um zaralho ter que digitar cada um desses comandos por vez
# é justamente por isso que eu criei esse script

# compilar o código
nasm -f bin src/boot.asm -o bin/boot.bin
nasm -f bin src/kernel.asm -o bin/kernel.bin

# criar a imagem de disco 
dd if=/dev/zero of=bin/disk.img bs=512 count=2880
dd if=bin/boot.bin of=bin/disk.img bs=512 seek=0 conv=notrunc
dd if=bin/kernel.bin of=bin/disk.img bs=512 seek=1 conv=notrunc

#rodar o código
qemu-system-i386 -drive format=raw,file=bin/disk.img 
