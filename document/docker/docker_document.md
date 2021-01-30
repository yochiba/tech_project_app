ubuntu:20.04


apt update
apt install -y sudo git

cd /var && mkdir -p www/html/app && cd www/html/app

git clone https://github.com/yochiba/tech_project_app.git

apt install vim

sudo apt install -y gcc build-essential libreadline-dev zlib1g-dev
sudo apt install -y libssl-dev
git clone https://github.com/rbenv/rbenv.git ~/.rbenv

git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

vim .bash_profile
以下を追加
```
export PATH="$HOME/.rbenv/bin:$PATH"
# eval "$(rbenv init -)"
```
source .bash_profile

rbenv install -l
