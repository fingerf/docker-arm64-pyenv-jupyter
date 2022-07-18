#!/usr/bin/env bash

# 打印检查环境是否导入
export INSTALL_DIR=/root/.pyenv
export PATH=/bin:/sbin:$INSTALL_DIR/bin:/usr/bin

echo $INSTALL_DIR
echo $PATH

mkdir_update_install(){
cp -rv /root/run_cp /usr/bin/
rm -rfv /root/run_cp
# 改时区
date '+%Y-%m-%d %H:%M:%S'
cp -rv /etc/localtime /etc/localtime.bak.`date '+%Y-%m-%d_%H-%M-%S'`
rm -rfv /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" > /etc/timezone
date '+%Y-%m-%d %H:%M:%S'

for((i=1;i<4;i++)) ; do
	echo "try $i"
	# 更新软件列表源
	apt-get update
	# 防止遇到无法拉取 https 源的情况，先使用 http 源并安装
	apt-get -y install apt-transport-https ca-certificates apt-utils
done

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
for((i=1;i<4;i++)) ; do
	echo "try $i"
	git clone https://github.com/pyenv/pyenv.git ~/.pyenv
	cd ~/.pyenv && src/configure && make -C src
done
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init -)"' >> ~/.profile
source $HOME/.bashrc $HOME/.profile

# clone pyenv 管理插件写入环境
for((i=1;i<4;i++)) ; do
	echo "try $i"
	git clone https://github.com/pyenv/pyenv-virtualenv.git `pyenv root`/plugins/pyenv-virtualenv
done
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
echo 'export PYENV_VIRTUALENV_DISABLE_PROMPT=1' >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.profile
echo 'export PYENV_VIRTUALENV_DISABLE_PROMPT=1' >> ~/.profile
source $HOME/.bashrc $HOME/.profile
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
