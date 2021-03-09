#!/bin/bash
cd /var/www/html/app/tech_project_app/client

yarn install && yarn build-${NODE_ENV} && yarn watch

yarn start