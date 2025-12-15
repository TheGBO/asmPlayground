#!/bin/bash

echo "ATENÇÃO, isso pode FODER COMPLETAMENTE qualquer dispositivo (e os dados) em /dev/sdb"
echo "Digite 'lsblk' para ter certeza do dispositivo"
read -r -p "Tem certeza do que está fazendo? [s/n]" response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    if [[ "$EUID" -ne 0 ]]; then
        echo "é necessário que você seja root para performar tal ação..."
        exec sudo "$0" "$@"
    fi
    sudo dd if=disk.img of=/dev/sdb bs=512 conv=notrunc status=progress
else
    exit
fi
