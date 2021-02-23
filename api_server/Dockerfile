FROM ruby:2.7.2-alpine

WORKDIR /var/www/html/app/tech_project_app/api_server

ENV DOCKER_ENV=development
ENV CORS_ALLOWED_ORIGINS_HOST=http://localhost
ENV MYSQL_USERNAME=root
ENV MYSQL_PASSWORD=test
ENV MYSQL_HOST=mysql
ENV MYSQL_PORT=3306
ENV REDIS_HOST=redis
ENV REDIS_PORT=6379
ENV TZ=Asia/Tokyo
ENV DOCKERIZE_VERSION v0.6.1

RUN apk add --no-cache alpine-sdk linux-headers libxml2-dev make tzdata \
    gcc libc-dev gmp-dev sudo bash curl vim git nodejs npm mysql-client mysql-dev wget && \
    apk add --virtual build-dependencies --no-cache build-base curl-dev && \
    wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    touch ~/.bashrc && \
    curl -o- -L https://yarnpkg.com/install.sh | bash && \
    ln -s "$HOME/.yarn/bin/yarn" /usr/local/bin/yarn && \
    # apiアプリケーション作成
    cd /var && mkdir -p www/html/app/tech_project_app/api_server && \
    cd www/html/app/tech_project_app/api_server

# COPY ./api_server.conf /etc/supervisord.d/
COPY ./entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3001