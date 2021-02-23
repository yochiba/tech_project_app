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
bundle exec sidekiq -C config/sidekiq.yml -d
bundle exec sidekiq -d -C config/sidekiq.yml --logfile ./log/sidekiq.log

rc-status
rc-update add supervisord

sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf && \
echo 'rc_provide="loopback net"' >> /etc/rc.conf && \
sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf && \
sed -i '/tty/d' /etc/inittab && \
sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname && \
sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh  && \
sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh && \
mkdir -p /run/openrc/ && \
touch /run/openrc/softlevel

rc-service supervisord start
rc-status