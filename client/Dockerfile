FROM node:14.15.4

ENV NODE_VERSION=14.15.4
ENV NODE_ENV=development
ENV TZ=Asia/Tokyo

RUN apt update -qq && apt install -y sudo vim git apt-transport-https \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
    && sudo apt -y update && sudo apt install -y yarn \
    && yarn -v \
    # create application
    && cd /var && mkdir -p www/html/app \
    && cd www/html/app/ \
    && git clone --depth 1 https://b9ca610614485d8b568ef218195d3f0ba0b1fa64:x-oauth-basic@github.com/yochiba/tech_project_app.git \
    && cd tech_project_app/ \
    && sudo rm -rf api_server document mysql nginx redis docker-compose.yml

WORKDIR /var/www/html/app/tech_project_app/client

COPY ./.env /var/www/html/app/tech_project_app/client

RUN yarn install && yarn build

EXPOSE 3000

CMD ["yarn", "start"]