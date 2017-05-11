FROM ubuntu:16.04

ADD https://github.com/spf13/hugo/releases/download/v0.20.7/hugo_0.20.7_Linux-64bit.deb /tmp

RUN dpkg -i /tmp/hugo_0.20.7_Linux-64bit.deb

RUN apt-get update \
    && apt-get install -y python3-pygments

WORKDIR /app

COPY . /app

CMD ["hugo", "server", "-w", "--bind", "0.0.0.0"]
