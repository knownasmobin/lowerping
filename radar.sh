#!/bin/bash

# Send the first curl request and extract the IP address
response=$(curl -k https://tehranwg.radar.game/getWGKey)
ip=$(echo $response | jq -r ".ip")
private_key=$(echo $response | jq -r ".private_key")
psk=$(echo $response | jq -r ".psk")

# Send the second curl request and extract the private_key, public_key, endpoint and dns
response=$(curl -k https://cdn.radar.game/app/vpn/tehranwireguard.json)
public_key=$(echo $response | jq -r ".publickey")
endpoint=$(echo $response | jq -r ".endpoint")
dns=$(echo $response | jq -r ".dns")

# Print the extracted values
echo IP: $ip
echo Private Key: $private_key
echo Public Key: $public_key
echo Endpoint: $endpoint
echo DNS: $dns


config=$(cat << EOF
[Interface]
PrivateKey = ${private_key}
Address = ${ip}
DNS = ${dns}

[Peer]
PublicKey = ${public_key}
PresharedKey =  ${psk}
Endpoint = ${endpoint}
AllowedIPs = 185.25.183.0/24, 180.149.41.0/24, 10.130.205.0/24, 116.202.224.146/32, 45.113.191.0/24,146.66.152.0/24, 146.66.158.0/24, 146.66.159.0/24
EOF
)

config=${config//\${private_key}/$private_key}
config=${config//\${ip}/$ip}
config=${config//\${dns}/$dns}
config=${config//\${public_key}/$public_key}
config=${config//\${psk}/$psk}
config=${config//\${endpoint}/$endpoint}

echo "$config" > ./CS-WG.conf