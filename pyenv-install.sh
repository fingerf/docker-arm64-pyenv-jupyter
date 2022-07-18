# 安装nodejs
apt-get install npm

# npm淘宝源
npm config set registry https://registry.npm.taobao.org 

# 大数据处理工具
pip install wheel gendoc pandas h5py tables pandas_datareader matplotlib lxml requests
# datatable 2022-06-25 不支持 3.10系列

# excel 文件读写, xlrd 2.0.1 开始不支持xlsx
pip install xlrd xlwt openpyxl 

# 自动化测试
pip install selenium apscheduler 

# 数据库
pip install psycopg2-binary mysql-connector-python pymongo mongoengine sqlalchemy 

# flask
pip install flask 

# 数据可视化
pip install altair cufflinks chart_studio bokeh pyecharts
 
# jupyter notebook 相关
pip install jupyter notebook voila jupyterlab jupyter-dash jupyterlab-dash jupyter_contrib_nbextensions 
 
# dash 相关
pip install dash plotly-express dash_bootstrap_components 

# 其他
pip install autopep8 yapf
 
# 生成 jupyter 默认配置文件
jupyter-notebook --generate-config --allow-root
 
# 跳过检查
jupyter contrib nbextension install --user --skip-running-check 
 
# jupyterlab插件
jupyter labextension install @jupyter-widgets/jupyterlab-manager 

# toc插件
jupyter labextension install @jupyterlab/toc 

# github插件
pip install --upgrade jupyterlab-git 

# jupyter labextension install @jupyterlab/github 
jupyter labextension install @jupyterlab/git 

# git插件
jupyter serverextension enable --py jupyterlab_git 

# latex插件
jupyter labextension install @jupyterlab/latex 

# http://draw.io插件
jupyter labextension install jupyterlab-drawio 

# plotly显示插件
jupyter labextension install jupyterlab-plotly 

# dash 显示插件
jupyter labextension install jupyterlab-dash 

# bokeh 显示插件
jupyter labextension install @bokeh/jupyter_bokeh 

# excel查看
jupyter labextension install jupyterlab-spreadsheet 

# 函数定义跳转
jupyter labextension install @krassowski/jupyterlab_go_to_definition 

# 变量探查
jupyter labextension install @lckr/jupyterlab_variableinspector 

# 执行时间
jupyter labextension install jupyterlab-execute-time 

# kite
wget -q -O ./kite-installer https://linux.kite.com/linux/current/kite-installer 
chmod 755 ./kite-installer && ./kite-installer install 
pip install jupyter-kite 
jupyter labextension install @kiteco/jupyterlab-kite  

# 调试插件（需要xeus-python内核)
pip install xeus-python 
jupyter labextension install @jupyterlab/debugger 

