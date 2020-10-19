#!/bin/sh

# version v4.31.2
# Download and install V2Ray
mkdir /tmp/trojan-go
curl -L -H "Cache-Control: no-cache" -o /tmp/trojan-go/trojan-go-linux-amd64.zip https://github.com/p4gefau1t/trojan-go/releases/download/v0.8.2/trojan-go-linux-amd64.zip

unzip /tmp/trojan-go/trojan-go-linux-amd64.zip -d /tmp/trojan-go

mkdir /usr/bin/trojan-go

install -m 755 /tmp/trojan-go/trojan-go /usr/bin/trojan-go/trojan-go
install -m 755 /tmp/trojan-go/geoip.dat /usr/bin/trojan-go/geoip.dat
install -m 755 /tmp/trojan-go/geosite.dat /usr/bin/trojan-go/geosite.dat


# Remove temporary directory
rm -rf /tmp/trojan-go

# trojan-go new configuration
# 注意 \\ 将会被转义 “\\” -> "\"
cat << EOF > /usr/bin/trojan-go/server.json
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": $PORT,
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "log_level": 1,
    "password": [
        "$UUID"
    ],
    "websocket": {
        "enabled": true,
        "path": "/$WSPATH"
    },
    "router": {
        "enabled": true,
        "block": [
            "geoip:private"
        ],
        "geoip": "/usr/bin/trojan-go/geoip.dat",
        "geosite": "/usr/bin/trojan-go/geosite.dat"
    }
}
EOF

cat /usr/bin/trojan-go/server.json
# Run trojan-go
/usr/bin/trojan-go/trojan-go -config /usr/bin/trojan-go/server.json