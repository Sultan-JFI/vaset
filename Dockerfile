FROM alpine:latest

RUN apk update && \
    apk add --no-cache shadowsocks-libev v2ray-plugin

ENV PASSWORD=YourSecurePassword
ENV METHOD=aes-256-gcm

CMD ss-server \
 -s 0.0.0.0 \
 -p 8080 \
 -k $PASSWORD \
 -m $METHOD \
 --plugin v2ray-plugin \
 --plugin-opts "server;path=/fly-tunnel"
