#!/bin/bash
packages=("curl" "lynx" "gawk" "grep" "sed")
for pkg in ${packages[@]}
do
    if [[ -z $(command -v $pkg) ]]
    then
        echo "$pkg belum terinstall"
        echo "$pkg akan segera diinstall"
        apt-get install $pkg -y | grep $pkg
    else
        echo "$pkg sudah lama terinstall ✔"
    fi
done
