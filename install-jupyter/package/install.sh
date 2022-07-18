#!/usr/bin/env bash

# 打印检查环境是否导入
export NOTEBOOK_ROOT=/notebook
export PASSWORD='123456'

echo $NOTEBOOK_ROOT
echo $PASSWORD

mkdir_update_install(){
# 改时区
date '+%Y-%m-%d %H:%M:%S'
cp -rv /etc/localtime /etc/localtime.bak.`date '+%Y-%m-%d_%H-%M-%S'`
rm -rfv /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" > /etc/timezone
date '+%Y-%m-%d %H:%M:%S'

# 新建 notebook 存储目录
mkdir -pv $NOTEBOOK_ROOT
cp -rv /root/run_jupyter /usr/bin/
rm -rfv /root/run_jupyter

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
	apt-get -y install procps htop python3-tk build-essential locales
        apt-get install -fy
done
}


pyenv_install(){
# 使用locale-gen命令生成中文本地支持
sed -i 's;# zh_CN.UTF-8 UTF-8;zh_CN.UTF-8 UTF-8;g' /etc/locale.gen

locale-gen zh_CN
locale-gen zh_CN.utf8
locale-gen zh_CN.UTF-8

# 写入环境变量
cat << EOF >> /root/.bashrc
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export LANGUAGE=zh_CN.UTF-8
EOF

cat << EOF >> /root/.profile
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export LANGUAGE=zh_CN.UTF-8
EOF

source /root/.bashrc /root/.profile

# 持久化
update-locale LANG=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8 LANGUAGE=zh_CN.UTF-8

# 看看当前启用的本地支持
cat /etc/default/locale
locale
locale -a

cd $HOME
# 解压已经编译好的压缩包
tar zxvf pyenv.tar.gz -C /root/

# 写入环境变量
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init -)"' >> ~/.profile
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
echo 'export PYENV_VIRTUALENV_DISABLE_PROMPT=1' >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.profile
echo 'export PYENV_VIRTUALENV_DISABLE_PROMPT=1' >> ~/.profile
source $HOME/.bashrc $HOME/.profile
pyenv_var=`pyenv versions | sed 's;*;;g;s;/; ;g' | grep -oE ' 3(.){1,7}' | awk '{print $1}'`
pyenv global $pyenv_var
pyenv virtualenv $pyenv_var pyenv
pyenv global pyenv $pyenv_var system
# python 版本
pyenv version
pyenv versions
}

jupyter_install(){
# 更新 pip
python -m pip install --upgrade pip

# 配置默认清华源
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip install pip -U

# jupyter notebook 相关
pip --no-cache-dir install jupyter notebook voila jupyterlab jupyter-dash jupyterlab-dash jupyter_contrib_nbextensions

# 生成 jupyter 默认配置文件
jupyter-notebook --generate-config --allow-root

# 跳过检查
jupyter contrib nbextension install --user --skip-running-check

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# 查看 jupyter 版本
jupyter --version

# 写入默认密码
cat << EOF | tee -a /root/.jupyter/jupyter_server_config.json
{
  "ServerApp": {
    "password": "`python -c "from notebook.auth import passwd; print(passwd('$PASSWORD'),end='')"`"
  }
}
EOF
cp -rv  /root/.jupyter /root/.jupyter.bak
}

clean_remove(){
# 清理
apt-get -y autoremove
apt-get -y autopurge
apt-get clean

rm -rfv  /var/lib/apt/lists/*

# 还原源
mv -v /etc/apt/sources.list.bak /etc/apt/sources.list
apt-get update

# 解除环境变量
unset NOTEBOOK_ROOT

# 删除压缩包
rm -rfv $HOME/pyenv.tar.gz

# 清除记录
history -c
echo '' > /root/.bash_history
}

mkdir_update_install
pyenv_install
jupyter_install
clean_remove
# 脚本终结
echo 'it is done!'
