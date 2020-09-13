#!/bin/sh

# Download and install V2Ray
mkdir /tmp/v2ray
curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray

mkdir /usr/bin/v2ray
install -m 755 /tmp/v2ray/v2ray /usr/bin/v2ray/v2ray
install -m 755 /tmp/v2ray/v2ctl /usr/bin/v2ray/v2ctl
install -m 755 /tmp/v2ray/geosite.dat /usr/bin/v2ray/geosite.dat
install -m 755 /tmp/v2ray/geoip.dat /usr/bin/v2ray/geoip.dat


# Remove temporary directory
rm -rf /tmp/v2ray

# V2Ray new configuration
cat << EOF > /usr/bin/v2ray/config.json
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "port": $PORT,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID",
                        "level": 0,
                        "email": "love@v2fly.org"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "wsSettings": {
                    "path": "/$WSPATH/"
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        },
        {
            "protocol": "socks",
            "tag": "tor",
            "settings": {
                "servers": [
                    {
                        "address": "127.0.0.1",
                        "port": 9050
                    }
                ]
            }
        }
    ],

    "routing": {
        "rules": [
            {
                "type": "field",
                "outboundTag": "tor",
                "domain": [
                    "regexp:\\.onion$"
                ]
            }
        ]
    }
}
EOF

cat /usr/bin/v2ray/config.json
# Run V2Ray
nohup tor & /usr/bin/v2ray/v2ray -config /usr/bin/v2ray/config.json
