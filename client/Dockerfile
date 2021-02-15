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
    && cd /var && mkdir -p www/html/app/tech_project_app/client \
    && cd www/html/app/tech_project_app/client

WORKDIR /var/www/html/app/tech_project_app/client

COPY ./entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000