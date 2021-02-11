FROM ruby:2.7.2

ENV CORS_ALLOWED_ORIGINS_HOST=http://localhost:8080
ENV MYSQL_USERNAME=root
ENV MYSQL_PASSWORD=test
ENV MYSQL_HOST=mysql
ENV REDIS_HOST=redis
ENV REDIS_PORT=6379
ENV TZ=Asia/Tokyo
ENV DOCKERIZE_VERSION v0.6.1

RUN apt update -qq && apt install -y sudo vim git build-essential libpq-dev nodejs npm mariadb-client wget \
    # dockerizeインストール
    && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    # node関連インストール
    && sudo npm install n -g \
    && sudo n stable \
    && sudo apt purge -y nodejs npm \
    && sudo n 14.15.4 \
    && node -v \
    # yarn install
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
    && sudo apt -y update && sudo apt install -y yarn \
    && yarn -v \
    && cd /var && mkdir -p www/html/app/tech_project_app/api_server

WORKDIR /var/www/html/app/tech_project_app/api_server

COPY . /var/www/html/app/tech_project_app/api_server

RUN bundle install

COPY ./config/database.yml /var/www/html/app/tech_project_app/api_server/config/

COPY ./entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3001
