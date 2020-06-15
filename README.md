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

$ sqlite3 /etc/postfix/vmail.sqlite

 CREATE TABLE users (email TEXT PRIMARY KEY, password TEXT, quota INTEGER DEFAULT 0);
 CREATE TABLE domains (id INTEGER PRIMARY KEY, domain TEXT UNIQUE);
 CREATE TABLE aliases (id INTEGER PRIMARY KEY, email TEXT UNIQUE, alias TEXT);

