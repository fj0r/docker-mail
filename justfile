build:
    docker build . -t nnurphy/mail:pg -f Dockerfile-pg

local:
    docker run --rm \
        --name mail \
        -e DOMAIN=localhost \
        -e EXTERNAL_IP=127.0.0.1 \
        -e MASTER=root \
        -v $PWD/mail:/var/spool/mail \
        -p 25:25 \
        -p 465:465 \
        -p 587:587 \
        -p 110:110 \
        -p 995:995 \
        -p 143:143 \
        -p 993:993 \
        nnurphy/mail:pg

run:
    docker run -d --restart=always \
        --name mail \
        -e DOMAIN=lizzie.fun \
        -e EXTERNAL_IP=67.218.158.11 \
        -e MASTER=root \
        -v $PWD/mail:/var/spool/mail \
        -p 25:25 \
        -p 465:465 \
        -p 587:587 \
        -p 110:110 \
        -p 995:995 \
        -p 143:143 \
        -p 993:993 \
        nnurphy/mail:pg