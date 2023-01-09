#!/bin/ksh
# after successful wireguard setup, this script will generate a new conf and
# put it in the setup.
wg_if="wg0"
port="51820"
iprange="10.0.0"
pub_ip=$(curl ipconfig.io)
# to use a dnsname instead of a public IP, run script like so:
## dnsname="my.server.com" ./new.sh
# or uncomment/populate the following line.
# dnsname="my.server.com"
endpoint="${dnsname:-$pub_ip}"
short_name=$(hostname -s)

cd /etc/wireguard || exit 1
newbit=$(( $(cat bit.txt) + 1 ))
echo $newbit > bit.txt
echo "enter client name (no spaces!)"
read name
mkdir -p "./$name"
wg genkey > "./$name/secret.key"
chmod 600 "./$name/secret.key"
wg pubkey < "./$name/secret.key" > "./$name/public.key"
config="# $name
[Peer]
PublicKey = $(cat "./$name/public.key")
AllowedIPs = ${iprange}.${newbit}/32
"
echo "$config" | tee -a $wg_if.conf

clientconf="[Interface]
PrivateKey = $(cat "./$name/secret.key")
Address = ${iprange}.${newbit}

[Peer]
PublicKey = $(cat public.key)
Endpoint = $endpoint:$port
AllowedIPs = 0.0.0.0/0, ::/0
"
echo "$clientconf" | tee "./${name}/${short_name}-${name}.conf"
sh /etc/netstart
