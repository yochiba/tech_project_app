FROM ruby:2.7.0

ENV MYSQL_USERNAME=root
ENV MYSQL_PASSWORD=test
ENV REDIS_HOST=redis
ENV REDIS_PORT=6379
ENV TZ=Asia/Tokyo

RUN apt update -qq && apt install -y sudo vim git build-essential libpq-dev nodejs npm mariadb-client \
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
    # create application
    && cd /var && mkdir -p www/html/app \
    && cd www/html/app \
    && git clone --depth 1 https://b9ca610614485d8b568ef218195d3f0ba0b1fa64:x-oauth-basic@github.com/yochiba/tech_project_app.git \
    && cd tech_project_app/ \
    && sudo rm -rf client document mysql nginx redis docker-compose.yml \
    && cd api_server/ \
    && bundle install

WORKDIR /var/www/html/app/tech_project_app/api_server

COPY ./config/database.yml /var/www/html/app/tech_project_app/api_server/config
COPY ./entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3001

# TODO change the command after -E depends on environment
CMD ["bundle", "exec", "unicorn_rails", "-D", "-p", "3001", "-E", "development"]