# unicornでのRails起動コマンド

## デーモン起動
```
bundle exec unicorn_rails -p 3001 -c config/unicorn.rb -E development -D
```

## 通常起動
```
bundle exec unicorn_rails -p 3001 -c config/unicorn.rb -E development
```

# redis起動
```
bundle exec sidekiq -C config/sidekiq.yml
```

# redis cli接続
```
redis-cli -p 6379
```

# デーモン化できない
bundle exec sidekiq -C config/sidekiq.yml

