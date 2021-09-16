#!/usr/bin/env bash

apt install -y gnupg2

curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor > /usr/share/keyrings/nginx-archive-keyring.gpg

printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://nginx.org/packages/mainline/debian bullseye nginx\n" > /etc/apt/sources.list.d/nginx.list

printf "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" > /etc/apt/preferences.d/99nginx

apt update -y

apt install -y nginx

mkdir -p /etc/systemd/system/nginx.service.d

printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf

bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

chown -R nobody:nogroup /etc/ssl/private/

wget -qO /etc/nginx/nginx.conf https://raw.githubusercontent.com/chika0801/tool/main/nginx.conf

wget -qO /usr/local/etc/xray/config.json https://raw.githubusercontent.com/chika0801/tool/main/config.json

wget -qO /usr/local/share/xray/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat

wget -qO /usr/local/share/xray/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat

systemctl daemon-reload

systemctl restart nginx

systemctl restart xray

printf "* 7 * * * /root/update_geodata.sh\n" > /root/update_geodata

printf "wget -qO /usr/local/share/xray/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat\nwget -qO /usr/local/share/xray/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat\nsleep 2\nsystemctl restart xray\n" > /root/update_geodata.sh

chmod +x update_geodata.sh

crontab update_geodata