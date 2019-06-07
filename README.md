# irc_mention

Linux cron script to grep irc mentions in log files and email them as el cheapo push notification.
I used this to setup IMAP SMTP relay on gmail https://medium.com/@yenthanh/config-your-sever-as-a-mta-mail-transfer-agent-using-sendmail-with-a-gmail-account-93bbf2eec6c1.
I also setup a gmail filter to mark my localhost.localdomain email to not be Spam.

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

# Project Title

One Paragraph of project description goes here

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

```
Give examples
```

### Installing

A step by step series of examples that tell you how to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc
