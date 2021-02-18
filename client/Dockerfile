FROM node:alpine3.13

ENV NODE_VERSION=14.15.4
ENV NODE_ENV=development
ENV TZ=Asia/Tokyo

RUN apk add --no-cache alpine-sdk linux-headers libxml2-dev tzdata \
    gcc libc-dev gmp-dev sudo bash curl vim git wget && \
    apk add --virtual build-dependencies --no-cache build-base curl-dev && \
    # create application
    cd /var && mkdir -p www/html/app/tech_project_app/client && \
    cd www/html/app/tech_project_app/client

WORKDIR /var/www/html/app/tech_project_app/client

COPY ./entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000