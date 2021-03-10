FROM nginx:alpine

WORKDIR /etc/nginx/conf.d

ENV TZ=Asia/Tokyo
ENV LANG ja_JP.UTF-8
ENV LC_TIME C

RUN apk add --no-cache alpine-sdk linux-headers libxml2-dev tzdata \
    gcc libc-dev gmp-dev sudo bash curl vim git wget && \
    apk add --virtual build-dependencies --no-cache build-base curl-dev && \
    sudo rm -f /etc/nginx/conf.d/default.conf && \
    sudo rm -f /etc/nginx/nginx.conf

COPY ./nginx.conf /etc/nginx/

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]