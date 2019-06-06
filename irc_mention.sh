#!/bin/bash -x

USER=prayther
DATE=$(/usr/bin/date +"%b %d")

if [ -f ./log/irc_last.log ];then
	touch ./log/irc_last.log
fi

rm -f ./log/irc_current.log
grep -i $USER * | grep "$DATE" >> ./log/irc_current.log

diff ./log/irc_current.log ./log/irc_last.log
if [ $? == 0 ];then
exit 0
fi

cp ./log/irc_current.log ./log/irc_last.log && /usr/sbin/sendmail -t <<EOF
From: prayther@localhost.localdomain
To: prayther@gmail.com
Subject: IRC mention
Content-Type: text/plain

$(cat ./log/irc_last.log)

EOF
