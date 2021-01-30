#!/bin/bash
set -e

rm -f /tech_project_app/tmp/pids/server.pid

touch ~/.bash_profile
echo "export CORS_ALLOWED_ORIGINS_HOST='http://localhost:8080'" >> ~/.bash_profile
echo "export MYSQL_USERNAME='root'" >> ~/.bash_profile
echo "export MYSQL_PASSWORD='test'" >> ~/.bash_profile
source ~/.bash_profile

cd /var/www/html/app/tech_project_app/api_server/config/
# TODO change the command after -e depends on environment
EDITOR="vi" rails credentials:edit -e development
cd ../
# TODO change the command after RAILS_ENV= depends on environment
rails db:create RAILS_ENV=development
rails db:migrate RAILS_ENV=development

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"