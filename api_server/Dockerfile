FROM ruby:2.7.2

ENV CORS_ALLOWED_ORIGINS_HOST=http://localhost:8080
ENV MYSQL_USERNAME=root
ENV MYSQL_PASSWORD=test
ENV MYSQL_HOST=mysql
ENV REDIS_HOST=redis
ENV REDIS_PORT=6379
ENV TZ=Asia/Tokyo
ENV DOCKERIZE_VERSION v0.6.1
# ユーザーを作成(開発者が任意で設定)　
ENV DEV_USER=dev_user
ENV DEV_PASSWPRD=test

RUN apt update -qq && apt install -y sudo vim git build-essential libpq-dev nodejs npm mariadb-client wget \
    # dockerizeインストール
    && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    # ユーザー作成
    && adduser --disabled-password --gecos '' ${DEV_USER} \
    # パスワード設定
    && echo ${DEV_USER}:${DEV_PASSWPRD} | chpasswd \
    # sudo 権限付与
    && gpasswd -a ${DEV_USER} sudo \
    && mkdir -p /home/${DEV_USER}/.ssh \
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
    # apiアプリケーション作成
    && cd /var && mkdir -p www/html/app \
    && cd www/html/app \
    && git clone --depth 1 https://b9ca610614485d8b568ef218195d3f0ba0b1fa64:x-oauth-basic@github.com/yochiba/tech_project_app.git \
    && cd tech_project_app/ \
    && sudo rm -rf client mysql nginx redis docker-compose.yml \
    && cd api_server/ \
    && bundle install

WORKDIR /var/www/html/app/tech_project_app/api_server

# database.yml
COPY ./config/database.yml /var/www/html/app/tech_project_app/api_server/config/
# keys for connect to github
COPY ./.ssh /home/${DEV_USER}/.ssh/

COPY ./entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3001
