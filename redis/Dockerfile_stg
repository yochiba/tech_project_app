FROM redis:rc-alpine3.12

ENV TZ=Asia/Tokyo

RUN apk add --no-cache alpine-sdk linux-headers libxml2-dev tzdata \
    gcc libc-dev gmp-dev sudo bash curl vim git wget && \
    apk add --virtual build-dependencies --no-cache build-base curl-dev

EXPOSE 6379

CMD ["redis-server"]