https://ubuverse.com/setting-up-your-own-mail-server-on-ubuntu/

And insert your mail server hostname in /etc/hosts and /etc/mailname.

$ nano /etc/hosts
YOUR_EXTERNAL_IP  MAIL.DOMAIN.TLD

$ nano /etc/mailname
MAIL.DOMAIN.TLD

$ nano /etc/postfix/aliases
root: USER@DOMAIN.TLD
postmaster: USER@DOMAIN.TLD
$ postalias /etc/postfix/aliases
