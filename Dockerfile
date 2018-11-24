FROM alpine:edge as build
MAINTAINER zhao weiqiang<zwq00000@gmail.com>

RUN apk --no-cache add tini git openssh-client \
    && apk --no-cache add --virtual devs tar curl

#Install Caddy Server, and All Middleware
RUN curl "https://caddyserver.com/download/linux/amd64?plugins=docker,http.expires,http.forwardproxy,http.ipfilter,http.jwt,http.login,http.realip&license=personal&telemetry=off" \
   | tar --no-same-owner -C /usr/bin/ -xz caddy
#Copy over a default Caddyfile


FROM scratch
MAINTAINER zhao weiqiang<zwq00000@gmail.com>
COPY rootfs /
COPY --from=build /usr/bin/caddy /bin/
EXPOSE 80 443 2015
WORKDIR /var/www/html

CMD ["/bin/caddy", "-quic", "--conf", "/etc/Caddyfile"]