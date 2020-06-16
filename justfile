build:
    docker build . -t nnurphy/mail:ext -f Dockerfile-ext

test:
    docker run -it --rm nnurphy/mail:ext

all: build test