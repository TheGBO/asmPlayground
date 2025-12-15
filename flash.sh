#!/bin/bash

echo "ATENÇÃO, isso pode FODER COMPLETAMENTE qualquer dispositivo (e os dados) em /dev/sdb"
echo "Digite 'lsblk' para ter certeza do dispositivo"
read -r -p "Tem certeza do que está fazendo? [y/n]" response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    sudo dd if=bin/disk.img of=/dev/sdb bs=512 conv=notrunc status=progress
else
    exit
fi
