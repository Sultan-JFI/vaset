# استفاده از لایه سبک Alpine برای سرعت حداکثری در Build
FROM alpine:latest

# تنظیم متغیرهای محیطی که خواستید
ENV UUID=d8f4306a-543e-4363-9993-4556488d5e9b
ENV WSPATH=/advanced-tunnel

# نصب ابزارهای مورد نیاز و دانلود هسته اصلی Xray
RUN apk add --no-cache curl unzip bash
RUN curl -L -H "Cache-Control: no-cache" -o /xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip /xray.zip && chmod +x /xray && rm /xray.zip

# ایجاد اسکریپت استارت‌آپ به صورت درجا (Inline) برای جلوگیری از خطای نبود فایل
RUN echo '#!/bin/bash \n\
echo "Generating config..." \n\
cat <<EOF > /config.json \n\
{ \n\
  "inbounds": [{ \n\
    "port": ${PORT:-10000}, \n\
    "protocol": "vless", \n\
    "settings": { \n\
      "clients": [{"id": "$UUID"}], \n\
      "decryption": "none" \n\
    }, \n\
    "streamSettings": { \n\
      "network": "ws", \n\
      "wsSettings": {"path": "$WSPATH"} \n\
    } \n\
  }], \n\
  "outbounds": [{"protocol": "freedom"}] \n\
} \n\
EOF \n\
echo "Starting Xray on Port $PORT with Path $WSPATH" \n\
/xray -config /config.json' > /entrypoint.sh && chmod +x /entrypoint.sh

# اجرای اسکریپت
CMD ["/bin/bash", "/entrypoint.sh"]