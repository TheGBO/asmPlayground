#!/bin/bash
# flash.sh
echo "ATENÇÃO, isso pode FODER COMPLETAMENTE qualquer dispositivo (e os dados) em /dev/sdb"
echo "Digite 'lsblk' para ter certeza do dispositivo"
read -r -p "Tem certeza do que está fazendo? [y/n]" response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    #recentemente descobri o que esse 2>/dev/null significa
    #é basicamente varrer sujeira pra debaixo do tapete
    
    sudo umount /dev/sdb* 2>/dev/null
    sudo dd if=bin/disk.img of=/dev/sdb bs=512 status=progress conv=fsync
    sync
    echo "gravação efetuada com sucesso"
else
    echo "operação abortada"
    exit
fi
