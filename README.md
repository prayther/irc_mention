# irc_mention
Linux cron script to grep irc mentions in log files and email them as el cheapo push notification.
I used this to setup IMAP smtp relay on gmail https://medium.com/@yenthanh/config-your-sever-as-a-mta-mail-transfer-agent-using-sendmail-with-a-gmail-account-93bbf2eec6c1.
I also setup a gmail filter to mark my localhost.localdomain email to not be put in Spam.

The gist of setting up gmail as a relay is (but the credit goes to Lê Yên Thanh
Want to know more about me? https://lythanh.xyz):

Install sendmail and config
First, install the sendmail:

$ sudo dnf install sendmail
Edit file /etc/hosts and make sure there is a line as below, this step is needed to help command ‘sendmailconfig’ run faster

127.0.0.1       localhost localhost.localdomain <your hostname>
Config sendmail with below command and press “Y” whenever requested:

sendmailconfig
Create your gmail account and add it into sendmail
Now, just go ahead and create your gmail account, remember the password as we need it for configuration.

Now we add the new gmail account into our server. Create a new directory:

mkdir -m 700 /etc/mail/authinfo/
cd /etc/mail/authinfo/
In the new directory, create a file named gmail-auth and input your gmail account here (don’t worry about your password, we will delete this file in the next steps):

AuthInfo: "U:root" "I:YOUR GMAIL ADDRESS" "P:YOUR GMAIL PASSWORD"
Create a hash for ‘gmail-auth’

makemap hash gmail-auth < gmail-auth
You can see a new file is created with name ‘gmail-auth.db’, we actually use this file for authentication with your gmail account so you can delete file ‘gmail-auth’ now

rm /etc/mail/authinfo/gmail-auth
Now we open file /etc/mail/sendmail.mc and add those lines, right above first “MAILER” definition line, DON’T PUT THE LINES ON TOP OF THE ‘sendmail.mc’ file

define(`SMART_HOST',`[smtp.gmail.com]')dnl
define(`RELAY_MAILER_ARGS', `TCP $h 587')dnl
define(`ESMTP_MAILER_ARGS', `TCP $h 587')dnl
define(`confAUTH_OPTIONS', `A p')dnl
TRUST_AUTH_MECH(`EXTERNAL DIGEST-MD5 CRAM-MD5 LOGIN PLAIN')dnl
define(`confAUTH_MECHANISMS', `EXTERNAL GSSAPI DIGEST-MD5 CRAM-MD5 LOGIN PLAIN')dnl
FEATURE(`authinfo',`hash -o /etc/mail/authinfo/gmail-auth.db')dnl
Finally, let’s build sendmail again and restart it

make -C /etc/mail
/etc/init.d/sendmail reload
Test sending email with ‘sendmail’ command
Now everything is done. Let’s try to send your first email to your ‘target-email@gmail.com’ with command:

/usr/sbin/sendmail -t <<EOF
To: target-email@gmail.com
Subject: my subject
Content-Type: text/html
hello world
EOF
