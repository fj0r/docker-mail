build:
    docker build . -t nnurphy/mail:ext -f Dockerfile-ext

test:
    docker run -it --rm nnurphy/mail:ext

all: build test

run:
    docker run -d --restart=always \
        -e DOMAIN=lizzie.fun \
        -e EXTERNAL_IP=67.218.158.11 \
        -e MASTER=nash \
        -v $PWD/mail:/var/spool/mail \
        --name mail \
        -p 25:25 \
        -p 465:465 \
        -p 587:587 \
        -p 110:110 \
        -p 995:995 \
        -p 143:143 \
        -p 993:993 \
        nnurphy/mail