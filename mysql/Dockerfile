FROM mysql:8.0.22

ENV MYSQL_ROOT_PASSWORD=test
ENV MYSQL_USER=root
ENV TZ=Asia/Tokyo

EXPOSE 3306

COPY ./my.cnf /etc/mysql/conf.d/my.cnf

CMD ["mysqld"]