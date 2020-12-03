set -eux

echo "${EXTERNAL_IP} ${DOMAIN}" >> /etc/hosts
echo "${DOMAIN}" >> /etc/mailname

sed -i 's/USER@DOMAIN\.TLD/'"${MASTER}@${DOMAIN}"'/' /etc/postfix/aliases

postalias /etc/postfix/aliases

while true; do
    inotifywait -re modify /etc
    service postfix restart
    service dovecot restart
done

