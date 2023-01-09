#!/bin/ksh
# wireguard on OpenBSD server setup
eth_if="vio0"
wg_if="wg0"
port="51820"

# install package
pkg_add wireguard-tools

# create interface
echo "inet 10.0.0.1 255.255.255.0 NONE
up
!/usr/local/bin/wg setconf $wg_if /etc/wireguard/$wg_if.conf" | tee /etc/hostname.wg0

# add firewall rules
echo "
#wireguard
pass in on $wg_if
pass in inet proto udp from any to any port $port
pass out on egress inet from ($wg_if:network) nat-to ($eth_if:0)" | tee -a /etc/pf.conf
pfctl -f /etc/pf.conf

# add sysctl parameters to use as VPN
sysctl net.inet.ip.forwarding=1
sysctl net.inet6.ip6.forwarding=1
echo "net.inet.ip.forwarding=1" >> /etc/sysctl.conf
echo "net.inet6.ip6.forwarding=1" >> /etc/sysctl.conf

# generate keys
mkdir -p /etc/wireguard
chmod 700 /etc/wireguard
[ -f new.sh ] && mv new.sh /etc/wireguard/
cd /etc/wireguard
wg genkey > secret.key
chmod 600 secret.key
wg pubkey < secret.key > public.key 
# create a file to keep track of client numbers
echo '1' > bit.txt

# create wg0.conf for interface
echo "[Interface]
PrivateKey = $(cat secret.key)
ListenPort = $port
" | tee /etc/wireguard/$wg_if.conf

