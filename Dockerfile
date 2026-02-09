FROM alpine:latest

# نصب شادوساکس و افزونه v2ray
RUN apk add --no-cache shadowsocks-libev

# تنظیمات متغیرها
ENV PASSWORD=YourSecurePassword
ENV METHOD=aes-256-gcm

# اجرای شادوساکس روی پورت داخلی 8080 با مود WebSocket
CMD ss-server -s 0.0.0.0 -p 8080 -k $PASSWORD -m $METHOD --plugin v2ray-plugin --plugin-opts "server;path=/fly-tunnel"
