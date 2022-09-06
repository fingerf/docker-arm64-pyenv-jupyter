#!/usr/bin/env bash

# 打印检查环境是否导入
export INSTALL_DIR=/root/.pyenv
export DEBIAN_FRONTEND=noninteractive
export PATH=$PATH:$INSTALL_DIR/bin


echo -e "$PATH \n$DEBIAN_FRONTEND"

mkdir_update_install(){
mkdir -pv $INSTALL_DIR
cp -rv /root/run_cp /usr/bin/
chmod -v u+x /usr/bin/run_cp
rm -rfv /root/run_cp
# 改时区
date '+%Y-%m-%d %H:%M:%S'
cp -rv /etc/localtime /etc/localtime.bak.`date '+%Y-%m-%d_%H-%M-%S'`
rm -rfv /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" > /etc/timezone
date '+%Y-%m-%d %H:%M:%S'

# for((i=1;i<4;i++)) ; do
# 	echo "try $i"
# 	# 更新软件列表源
# 	apt-get update
# 	# 防止遇到无法拉取 https 源的情况，先使用 http 源并安装
# 	apt-get -y install apt-transport-https ca-certificates apt-utils
# done

dpkg -i /root/*.deb

rm -rfv /root/*.deb

# 备份源
cp -rv /etc/apt/sources.list /etc/apt/sources.list.bak

# 写入清华源
cat << EOF > /etc/apt/sources.list
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
EOF

for((i=1;i<4;i++)) ; do
	echo "try $i"
	# 更新软件列表源
	apt-get update
	# 安装一些工具和 pyenv python 必备依赖
	apt-get -y install vim git neofetch procps htop \
		python3-tk make build-essential libssl-dev zlib1g-dev \
		libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
		libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev \
		liblzma-dev
done
}

git_clone(){

# clone 编译 pyenv 写入环境
# for((i=1;i<4;i++)) ; do
# 	echo "try $i"
# 	# git clone https://github.com/pyenv/pyenv.git ~/.pyenv
#       # curl -L -H "Connection: keep-alive" -k "https://github.com`curl -L 'https://github.com/pyenv/pyenv/releases' | grep '.tar.gz' | sed 's;";  ;g' | awk '{print $3}' | head -n 1`" -o pyenv.tar.gz -O
#       tar zxvf pyenv.tar.gz -C ~/.pyenv
#       mv -v .pyenv/*/.* .pyenv/*/* .pyenv/
# 	cd ~/.pyenv && src/configure && make -C src
# done

tar zxvf /root/pyenv.tar.gz -C $INSTALL_DIR
mv -v $INSTALL_DIR/*/.[^.]* $INSTALL_DIR/*/* $INSTALL_DIR/
cd $INSTALL_DIR && src/configure && make -C src

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $HOME/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> $HOME/.bashrc
echo 'eval "$(pyenv init -)"' >> $HOME/.bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $HOME/.profile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> $HOME/.profile
echo 'eval "$(pyenv init -)"' >> $HOME/.profile
source $HOME/.bashrc $HOME/.profile

# clone pyenv 管理插件写入环境
# for((i=1;i<4;i++)) ; do
# 	echo "try $i"
# 	# git clone https://github.com/pyenv/pyenv-virtualenv.git `pyenv root`/plugins/pyenv-virtualenv
#       # curl -L -H "Connection: keep-alive" -k "https://github.com`curl -L 'https://github.com/pyenv/pyenv-virtualenv/releases' | grep '.tar.gz' | sed 's;";  ;g' | awk '{print $3}' | head -n 1`" -o pyenv-virtualenv.tar.gz -O
#       tar zxvf pyenv-virtualenv.tar.gz -C `pyenv root`/plugins/pyenv-virtualenv
#       mv -v `pyenv root`/plugins/pyenv-virtualenv/*/.* `pyenv root`/plugins/pyenv-virtualenv/*/* `pyenv root`/plugins/pyenv-virtualenv/
# done

mkdir -pv `pyenv root`/plugins/pyenv-virtualenv
tar zxvf /root/pyenv-virtualenv.tar.gz -C `pyenv root`/plugins/pyenv-virtualenv
mv -v `pyenv root`/plugins/pyenv-virtualenv/*/.[^.]* `pyenv root`/plugins/pyenv-virtualenv/*/* `pyenv root`/plugins/pyenv-virtualenv/

echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/.bashrc
echo 'export PYENV_VIRTUALENV_DISABLE_PROMPT=1' >> $HOME/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/.profile
echo 'export PYENV_VIRTUALENV_DISABLE_PROMPT=1' >> $HOME/.profile
source $HOME/.bashrc $HOME/.profile
rm -rfv /root/pyenv-virtualenv.tar.gz /root/pyenv.tar.gz
}

clean_remove(){
# 清理
# apt-get -y purge make libssl-dev zlib1g-dev \
# 	libbz2-dev libreadline-dev wget curl llvm \
# 	libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev \
# 	liblzma-dev
# for((i=1;i<4;i++)) ; do
# 	echo "try $i"
# 	apt-get -y install procps htop python3-tk build-essential
# 	apt-get install -fy
# done
apt-get -y autoremove
apt-get -y autopurge
apt-get clean

rm -rfv  /var/lib/apt/lists/*

# 还原源
mv -v /etc/apt/sources.list.bak /etc/apt/sources.list
apt-get update

# 解除环境变量
unset INSTALL_DIR
unset PATH

# 清除记录
history -c
echo '' > /root/.bash_history
}

mkdir_update_install
git_clone
clean_remove
# 脚本终结
echo 'it is done!'
