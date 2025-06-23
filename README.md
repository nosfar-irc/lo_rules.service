# lo_rules.service
Service checking ip rules for lo interface for stunnel and ircd

Create main executable script 
```
sudo vi /usr/local/bin/lo_rules.sh
```
```
#!/bin/bash
LOGFILE="/var/log/lo_rules.log"
GREP_RULE="from 127.0.0.1/8 iif lo lookup 123"

echo "Service started at $(date)" >> "$LOGFILE"

while true; do

  if ip rule show | grep -qF "$GREP_RULE"; then
    :
  else
    ip rule add from 127.0.0.1/8 iif lo table 123
    ip -6 rule add from ::1/128 iif lo table 123
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Added rules for \"iif lo table 123\" " >> "$LOGFILE"
  fi

  sleep 20
done
```

```
sudo chmod +x /usr/local/bin/lo_rules.sh
```

And `systemd` service script
```
sudo vi /etc/systemd/system/lo_rules.service
```
```
[Unit]
Description=Service checking ip rules at lo interface for stunnel and ircd
After=network.target
[Service]
ExecStart=/usr/local/bin/lo_rules.sh
Restart=always
User=root
[Install]
WantedBy=multi-user.target
```

At the end reload deamon, enable and start service `lo_rules`
```
sudo systemctl daemon-reload
```
```
sudo systemctl enable lo_rules
```
```
sudo systemctl start lo_rules
```
