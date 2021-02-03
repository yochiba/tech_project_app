FROM nginx:stable-perl

RUN apt update && apt install -y apt-utils locales procps sudo vim \
    && sed -i -e 's/# ja_JP.UTF-8/ja_JP.UTF-8/g' /etc/locale.gen \
    && locale-gen ja_JP.UTF-8 \
    && sudo rm -f /etc/nginx/conf.d/default.conf \
    && sudo rm -f /etc/nginx/conf.d/nginx.conf

ENV TZ=Asia/Tokyo
ENV LANG ja_JP.UTF-8
ENV LC_TIME C

WORKDIR /etc/nginx/conf.d

EXPOSE 80 443

COPY ./nginx.conf /etc/nginx/
COPY ./techies_guild.conf /etc/nginx/conf.d/

CMD ["nginx", "-g", "daemon off;"]