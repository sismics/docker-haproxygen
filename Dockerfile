#
# Dockerfile for Haproxy + Dockergen
#
# Instructions:
#
# docker build -t sismics/haproxygen .
# docker volume create --name letsencrypt_etc
# docker volume create --name acme_webroot
# docker run -d -h haproxygen --name haproxygen -p 80:80 -p 443:443 -v /var/run/docker.sock:/var/run/docker.sock
#     -v letsencrypt_etc:/etc/letsencrypt
#     -v acme_webroot:/var/acme-webroot
#     sismics/haproxygen
# docker run -d --env=VIRTUAL_HOST_SECURE=yoursite.com --env=VIRTUAL_PORT=8080 --name yoursite webserver_image

FROM debian:jessie
MAINTAINER Jean-Marc Tremeaux <jm.tremeaux@sismics.com>

# Run Debian in non interactive mode
ENV DEBIAN_FRONTEND noninteractive

# Install Debian base
RUN sed -i 's/main/main contrib/' /etc/apt/sources.list
RUN apt-get update && apt-get -y -q install vim less procps supervisor inotify-tools curl git make libssl-dev ca-certificates
RUN echo deb http://httpredir.debian.org/debian jessie-backports main | \
                   sed 's/\(.*\)-sloppy \(.*\)/&@\1 \2/' | tr @ '\n' | \
                   tee /etc/apt/sources.list.d/backports.list
RUN apt-get update && apt-get install -y -t jessie-backports haproxy liblua5.3-dev

# Install Luasec
RUN git clone https://github.com/brunoos/luasec.git /usr/src/lua-sec
WORKDIR /usr/src/lua-sec
ENV LUAPATH=/usr/share/lua/5.3/
ENV LUACPATH=/usr/lib/lua/5.3/
ENV INC_PATH="-I/usr/include/lua5.3/"
RUN make linux && make install
RUN rm -rf /usr/src/lua-sec

# Install Dockergen
ENV DOCKERGEN_VERSION 0.7.0
RUN curl -L "https://www.github.com/jwilder/docker-gen/releases/download/${DOCKERGEN_VERSION}/docker-gen-linux-amd64-${DOCKERGEN_VERSION}.tar.gz" | \
  tar --directory=/usr/local/bin -x -z
COPY config /config
COPY etc /etc
COPY usr /usr
RUN mkdir /var/dockergen /data

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-n"]
