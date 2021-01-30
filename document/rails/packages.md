# unicornでのRails起動コマンド

## デーモン起動
```
bundle exec unicorn_rails -D -p 3001 -c config/unicorn.rb -E development
```

## 通常起動
```
bundle exec unicorn_rails -p 3001 -c config/unicorn.rb -E development
```


# redis起動
```
bundle exec sidekiq -C config/sidekiq.yml
```

EDITOR="vi" rails credentials:edit -e development
cd ../
# TODO change the command after RAILS_ENV= depends on environment
rails db:create RAILS_ENV=development
rails db:migrate RAILS_ENV=development
# デーモン化できない
bundle exec sidekiq -C config/sidekiq.yml


docker push yoshiiito0221/techies_guild:api_server
docker push yoshiiito0221/techies_guild:client
docker push yoshiiito0221/techies_guild:nginx
docker push yoshiiito0221/techies_guild:redis
docker push yoshiiito0221/techies_guild:mysql

docker tag e4e1f466cede yoshiiito0221/techies_guild:api_server
docker tag 51824c4ced06 yoshiiito0221/techies_guild:client
docker tag 299274278827 yoshiiito0221/techies_guild:nginx
docker tag 279490e06e9a yoshiiito0221/techies_guild:redis
docker tag 171f086c8910 yoshiiito0221/techies_guild:mysql

