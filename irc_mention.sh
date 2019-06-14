#!/bin/bash -x

# redirect everything
logfile=/var/log/irc_mention.log
exec > $logfile 2>&1

DIR=/home/<account>/.config/hexchat/logs/<server> #or wherever the logs are for your client
IRC_USER=<handle>
EMAIL=<email@address.org>
DATE=$(/usr/bin/date +"%b %d")
LogDate=$(/usr/bin/date +"%b %d %R") # this is to capture 30 seconds + from maillog. LogDateEnd is set below
NETWORK=<network>.log

if [ ! -f /tmp/irc_current.log ];then
	touch /tmp/irc_current.log
fi

if [ ! -f /tmp/irc_last.log ];then
	touch /tmp/irc_last.log
fi

for Private_Channels in $(ls ${DIR}/ | grep -v \# | grep -v ${NETWORK} | grep -v server.log | grep -v rhat.log);do
        cat ${DIR}/${Private_Channels}* | grep "${DATE}" >> /tmp/irc_current.log
done

for Channels in $(ls ${DIR}/\#*);do
        grep --directories=skip -i ${IRC_USER} ${Channels} | grep "${DATE}" >> /tmp/irc_current.log
done

diff /tmp/irc_current.log /tmp/irc_last.log
if [ $? == 0 ];then
exit 0
fi

mv /tmp/irc_current.log /tmp/irc_last.log

/usr/sbin/sendmail -t <<EOF
From: $(hostname)@localhost.localdomain
To: ${EMAIL}
Subject: IRC mention
Content-Type: text/plain
X-Priority: 1 (Highest)
X-MSMail-Priority: High

$(cat /tmp/irc_last.log)

EOF

LogDateEnd=$(/usr/bin/date +"%b %d %R" -d "+30 seconds")
sleep 30
sed -n "/${LogDate}/,/${LogDateEnd}/p" /var/log/maillog >> /var/log/irc_mention.log
