FROM alpine:3.9

ARG SSR_URL=https://github.com/winterssy/shadowsocksr/archive/manyuser.zip

RUN set -ex && \
    apk --update add --no-cache libsodium py-pip && \
    pip --no-cache-dir install $SSR_URL

WORKDIR /ssr

COPY etc/config.json .

CMD ["ssserver", "-c", "config.json"]
