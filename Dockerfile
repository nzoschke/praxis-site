FROM ubuntu:16.04

RUN apt-get -y update && apt-get install -y python-pip
RUN pip install pygments

ADD https://github.com/spf13/hugo/releases/download/v0.20.7/hugo_0.20.7_Linux-64bit.deb /tmp
RUN dpkg -i /tmp/hugo_0.20.7_Linux-64bit.deb

WORKDIR /app

COPY . /app

CMD ["hugo", "server", "-w", "--bind", "0.0.0.0"]
