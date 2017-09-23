FROM docker.io/alpine:3.6
MAINTAINER Claudio Souza <jcfigueiredo@gmail.com>
# base on Raul Sanchez <rawmind@gmail.com>

# Install basic packages and config monit
RUN apk add --update bash monit openssl openssh curl && rm -rf /var/cacke/apk/* \
  && mkdir -p /etc/monit/conf.d/
COPY monit/monitrc /etc/monitrc
RUN chown root:root /etc/monitrc && chmod 700 /etc/monitrc
COPY monit/basic /etc/monit/conf.d/basic

# Install compile and install confd
ENV CONFD_VERSION=v0.13.0 GOMAXPROCS=2 \
    GOROOT=/usr/lib/go \
    GOPATH=/opt/src \
    GOBIN=/gopath/bin \
    PATH="$PATH:/opt/confd/bin"

RUN mkdir -p /opt/confd/bin && mkdir -p /etc/confd/templates /etc/confd/conf.d
COPY ./bin/confd-0.13.0-linux-amd64 /opt/confd/bin/confd

# Install selfsigned ca (optional)
#COPY <ca.crt> /etc/ssl/certs/<ca.pem>
#RUN cat /etc/ssl/certs/<ca.pem> >> /etc/ssl/certs/ca-certificates.crt && \
   #cd /etc/ssl/certs/ && \
   #ln -s <ca.pem> `openssl x509 -hash -noout -in <ca.pem>`.0

CMD ["/usr/bin/monit", "-I"]
