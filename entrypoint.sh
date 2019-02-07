#!/bin/bash

F2B_LOG_LEVEL=${F2B_LOG_LEVEL:-INFO}
F2B_DB_PURGE_AGE=${F2B_DB_PURGE_AGE:-1d}
F2B_IGNORE_SELF=${F2B_IGNORE_SELF:-true}
F2B_IGNORE_IP=${F2B_IGNORE_IP:-127.0.0.1/8 ::1}
F2B_BAN_TIME=${F2B_BAN_TIME:-10m}
F2B_FIND_TIME=${F2B_FIND_TIME:-10m}
F2B_MAX_RETRY=${F2B_MAX_RETRY:-5}
F2B_DEST_EMAIL=${F2B_DEST_EMAIL:-root@localhost}
F2B_SENDER=${F2B_SENDER:-root@$(hostname -f)}
F2B_ACTION=${F2B_ACTION:-%(action_)s}
F2B_IPTABLES_CHAIN=${F2B_IPTABLES_CHAIN:-INPUT}

SSMTP_PORT=${SSMTP_PORT:-25}
SSMTP_HOSTNAME=${SSMTP_HOSTNAME:-$(hostname -f)}
SSMTP_TLS=${SSMTP_TLS:-NO}

# Fail2ban conf
echo "Setting Fail2ban configuration..."

echo "Create file: /etc/fail2ban/fail2ban.local"
cat > /etc/fail2ban/fail2ban.local <<EOL
[Definition]
loglevel = ${F2B_LOG_LEVEL}
logtarget = STDOUT
dbpurgeage  = ${F2B_DB_PURGE_AGE}
EOL

echo "Create file: /etc/fail2ban/action.d/iptables-common.local"
cat > /etc/fail2ban/action.d/iptables-common.local <<EOL
[Init]
chain = ${F2B_IPTABLES_CHAIN}
EOL

echo "Create file /etc/fail2ban/jail.local"
cat > /etc/fail2ban/jail.local <<EOL
[DEFAULT]
ignoreself = ${F2B_IGNORE_SELF}
ignoreip = ${F2B_IGNORE_IP}
bantime = ${F2B_BAN_TIME}
findtime = ${F2B_FIND_TIME}
maxretry = ${F2B_MAX_RETRY}
destemail = ${F2B_DEST_EMAIL}
sender = ${F2B_SENDER}
action = ${F2B_ACTION}
EOL

# launch the process in parameters
exec "$@"

