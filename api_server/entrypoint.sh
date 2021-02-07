#!/bin/bash
echo "entrypoint.sh start"
set -es

rm -f /var/www/html/app/tech_project_app/api_servertmp/pids/server.pid
rm -f /var/www/html/app/tech_project_app/api_servertmp/pids/unicorn.pid

cd /var/www/html/app/tech_project_app/api_server

# mysqlが起動するまでwait
dockerize -wait tcp://mysql:3306 -timeout 5m

rails db:create RAILS_ENV=development
rails db:migrate RAILS_ENV=development

# Then exec the container's main process (what's set as CMD in the Dockerfile).
bundle exec unicorn_rails -p 3001 -c config/unicorn.rb -E development
# exec "$@"