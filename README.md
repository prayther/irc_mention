# irc_mention
irc_mention.sh is a cron script to grep irc mentions in log files and email them as el cheapo push notification.
I used this to setup IMAP SMTP relay on gmail https://medium.com/@yenthanh/config-your-sever-as-a-mta-mail-transfer-agent-using-sendmail-with-a-gmail-account-93bbf2eec6c1. Below is a synopsis of the URL.

Setup a gmail filter (not just clicking on the email to say "Not Spam") to mark the incoming email to not be Spam. We are breaking every rule of email and gmail smartly demnands that it is Spam.

The gist of setting up gmail as a relay is (but the credit goes to Lê Yên Thanh
Want to know more about me? https://lythanh.xyz):
## Install sendmail:
```
$ sudo dnf install sendmail
```
## Edit file /etc/hosts
Without it sendmail is confused and won't start.
```
127.0.0.1       localhost localhost.localdomain <your hostname>
```
## Create an gmail account so you can use the credentials with IMAP for SMTP
Create a new directory:
```
mkdir -m 700 /etc/mail/authinfo/
cd /etc/mail/authinfo/
```
## In the new directory, create a file named gmail-auth and input your gmail account info.
```
AuthInfo: "U:root" "I:YOUR GMAIL ADDRESS" "P:YOUR GMAIL PASSWORD"
```
## Create a hash for ‘gmail-auth’
```
makemap hash gmail-auth < gmail-auth
```
## A new file is created with name ‘gmail-auth.db’, we actually use this file for authentication with your gmail account so you can delete file ‘gmail-auth’ now
```
rm /etc/mail/authinfo/gmail-auth
```
## Open file /etc/mail/sendmail.mc and add those lines, right above first “MAILER” definition line, DON’T PUT THE LINES 
ON TOP OF THE ‘sendmail.mc’ file
```
define(`SMART_HOST',`[smtp.gmail.com]')dnl
define(`RELAY_MAILER_ARGS', `TCP $h 587')dnl
define(`ESMTP_MAILER_ARGS', `TCP $h 587')dnl
define(`confAUTH_OPTIONS', `A p')dnl
TRUST_AUTH_MECH(`EXTERNAL DIGEST-MD5 CRAM-MD5 LOGIN PLAIN')dnl
define(`confAUTH_MECHANISMS', `EXTERNAL GSSAPI DIGEST-MD5 CRAM-MD5 LOGIN PLAIN')dnl
FEATURE(`authinfo',`hash -o /etc/mail/authinfo/gmail-auth.db')dnl
```
You can confirm the google SMTP info from your gmail->Settings->IMAP
## Restart sendmail
```
systemctl enable sendmail

systemctl restart sendmail
```
## Test sending email with ‘sendmail’ command
Now everything is done. Let’s try to send your first email to your ‘target-email@gmail.com’ with command:
```
/usr/sbin/sendmail -t <<EOF
To: target-email@gmail.com
Subject: my subject
Content-Type: text/plain
hello world
EOF
```
If you have want html in your email body then use 'text/html' above.
