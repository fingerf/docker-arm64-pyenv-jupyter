# docker-arm64-pyenv-jupyter
## 描述
    这是包含了 pyenv 和 jupyter 两个部分的 docker 构建材料  
    主要目的是为了使用 jupyter 本来没想这么复杂，我就是觉得 pyenv 好，为了自己的追求，只能辛苦一下  
    这个应该是可以改成分段构建的项目，我觉得怕中间出错，不敢把他们写成分段式构建，以后有机会我在改  
    以下是思路：  
      * 先构建 pyenv 配置最新的 python 环境并打包复制到 jupyter 环境目录，最后终止容器，实在太慢，我都哭了 >_<
      * 然后在 jupyter 环境将 pyenv 包解压配置环境变量安装 jupyter 然后维持其运行，这样容器就不会自己停止 
    dockerhub 已经上传镜像： 
      * https://hub.docker.com/repository/docker/smallflowercat1995/debian-pyenv
      * https://hub.docker.com/repository/docker/smallflowercat1995/debian-jupyter
    .
    ├── build-pyenv                                  # 这个是构建 pyenv 并将其打包到 jupyter 环境目录  
    │   ├── docker-compose.yml                       # 这个是构建 pyenv 的 docker-compose.yml 配置文件  
    │   ├── Dockerfile                               # 这个是构建 pyenv 的 docker 构建文件  
    │   └── package                                  # 这个是构建 pyenv 的脚本文件所在目录  
    │       ├── apt-transport-https_2.2.4_all.deb    # 这个是 apt-transport-https 安装包  
    │       ├── apt-utils_2.2.4_arm64.deb            # 这个是 apt-utils 安装包  
    │       ├── ca-certificates_20210119_all.deb     # 这个是 ca-certificates 安装包  
    │       ├── install.sh                           # 这个是构建 pyenv 镜像的时候在容器内执行流程的脚本   
    │       ├── openssl_1.1.1n-0+deb11u3_arm64.deb   # 这个是 openssl 安装包   
    │       ├── pyenv.tar.gz                         # 这个是 pyenv 官方源码包  
    │       ├── pyenv-virtualenv.tar.gz              # 这个是 pyenv-virtualenv 官方源码包  
    │       └── run_cp                               # 这个是构建 pyenv 完成时最终会执行的打包拷贝脚本  
    ├── install-jupyter
    │   ├── docker-compose.yml                       # 这个是构建 jupyter 的 docker-compose.yml 配置文件，默认端口 8888  
    │   ├── Dockerfile                               # 这个是构建 jupyter 的 docker 构建文件  
    │   └── package                                  # 这个是构建 jupyter 的脚本文件、pyenv包文件所在目录  
    │       ├── apt-transport-https_2.2.4_all.deb    # 这个是 apt-transport-https 安装包  
    │       ├── apt-utils_2.2.4_arm64.deb            # 这个是 apt-utils 安装包  
    │       ├── ca-certificates_20210119_all.deb     # 这个是 ca-certificates 安装包  
    │       ├── install.sh                           # 这个是构建 jupyter 镜像的时候在容器内执行流程的脚本，默认密码 123456  
    │       ├── openssl_1.1.1n-0+deb11u3_arm64.deb   # 这个是 openssl 安装包  
    │       └── run_jupyter                          # 这个是启动 jupyter 的脚本  
    ├── pyenv-install.sh                             # 这个是 pip 可能需要安装一些工具的脚本，没啥用，我一次也没执行过  
    └── update.sh                                    # 这个是 actions 所需要的自动更新 pyenv 和 pyenv-virtualenv 官方源码包脚本  


## 依赖
    arm64 设备
    docker 程序
    docker-compose python程序
    我目前能想到的必要程序就这些吧

## 构建命令
### 部分一：编译 pyenv 环境并打包到 docker-arm64-pyenv-jupyter/install-jupyter/package 中
    # clone 项目
    git clone https://github.com/smallflowercat1995/docker-arm64-pyenv-jupyter.git
    # 进入目录
    cd docker-arm64-pyenv-jupyter/build-pyenv
    # 无缓存构建
    docker-compose build --no-cache
    # 构建完成后 后台启动 等待 pyenv 环境编译打包，之后这个容器会终止
    # 此后每次重新执行第一部分容器都会重新编译拿出压缩包
    docker-compose up -d
    # 也可以查看日志看看有没有打包完成 会提示 ok done!  
    docker-compose logs -f
### 部分二：编译 jupyter 环境
    # 进入目录
    cd ../install-jupyter/
    # 无缓存构建
    docker-compose build --no-cache
    # 构建完成后 后台启动
    docker-compose up -d
    # 也可以查看日志看看有没有失败 
    docker-compose logs -f

## 默认密码以及修改
    # 别担心我料到这一点了，毕竟我自己还要用呢
    # 首先访问 http://[主机IP]:8888 输入默认密码 123456
    # 然后如图打开终端 在终端内执行密码修改指令 需输入两次 密码不会显示属于正常现象 密码配置文件会保存到容器内的 $HOME/.jupyter/jupyter_server_config.json 
    jupyter-lab password
   <img src="https://user-images.githubusercontent.com/94947393/179494632-fccd5e68-6d44-440c-b56d-82e8813c837d.png" title="打开终端" alt="打开终端" style="zoom: 50%;" />
   <img src="https://user-images.githubusercontent.com/94947393/179495057-b3a2148c-3abe-401f-98c7-647cd6521141.png" title="密码修改指令" alt="密码修改指令" style="zoom: 50%;" />

## 修改新增
    # 将在线克隆的方式注释了，太卡了，卡哭我了，哭了一晚上 >_< 呜呜呜
    # actions 自动获取 pyenv 和 pyenv-virtualenv   

## 感谢
jupyter 官网：https://jupyter.org/install    
大佬 pyenv：https://github.com/pyenv

## 参考
install jupyter-lab：https://jupyterlab.readthedocs.io/en/latest/getting_started/installation.html  
Common Extension Points：https://jupyterlab.readthedocs.io/en/latest/extension/extension_points.html   
pyenv：https://github.com/pyenv/pyenv  
virtualenv：https://github.com/pyenv/pyenv-virtualenv  
