#!/bin/bash -x

DIR=/home/<account>/.config/hexchat/logs/<server> #or wherever the logs are for your client
IRC_USER=<handle>
EMAIL=<email@address.org>
DATE=$(/usr/bin/date +"%b %d")

if [ ! -f /tmp/irc_current.log ];then
	touch /tmp/irc_current.log
fi

if [ ! -f /tmp/irc_last.log ];then
	touch /tmp/irc_last.log
fi

grep --directories=skip -i ${IRC_USER} ${DIR}/* | grep "${DATE}" > /tmp/irc_current.log

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

$(cat /tmp/irc_last.log)

EOF
