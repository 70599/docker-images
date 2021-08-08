#!/bin/sh

[[ -z "$VER" ]] && VER=$(curl -sL https://api.github.com/repos/XTLS/Xray-core/tags | grep name | head -n 1 | cut -d '"' -f 4)

arch=linux-64
name=Xray-$arch
file=$name.zip
tmp=/tmp/xray

[ -e $tmp ] || mkdir -p $tmp
cd $tmp
echo "VER is $VER"

wget https://github.com/XTLS/Xray-core/releases/download/$VER/$file

unzip $file
cp -f ./xray /usr/bin/
chmod +x /usr/bin/xray
rm -rf $tmp
