#!/bin/sh

repo="lxhao61/integrated-examples"

cd /tmp

url=$(curl -sL https://api.github.com/repos/$repo/releases | jq -r '.[0].assets[].browser_download_url' | grep 'linux' | grep -E 'x86_64|amd64' | head -n 1)
[ -n $url ] && wget -c $url -O - | tar -xz

if [[ $? == 0 ]]; then
	[ -x caddy ] || chmod +x caddy
	upx --ultra-brute caddy
fi
