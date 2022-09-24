#!/usr/bin/env bash
# 失效了？
# curl -L -H "Connection: keep-alive" -k "https://github.com`curl -L 'https://github.com/pyenv/pyenv/releases' | grep '.tar.gz' | sed 's;";  ;g' | awk '{print $3}' | head -n 1`" -o build-pyenv/package/pyenv.tar.gz -O
curl -L -H "Connection: keep-alive" -k "https://github.com`curl -L 'https://github.com/pyenv/pyenv/releases' | sed 's;";\n;g;s;releases/tag;archive/refs/tags;g' | grep '/tags/' | head -n 1`.tar.gz" -o build-pyenv/package/pyenv.tar.gz -O

# 失效了？
# curl -L -H "Connection: keep-alive" -k "https://github.com`curl -L 'https://github.com/pyenv/pyenv-virtualenv/releases' | grep '.tar.gz' | sed 's;";  ;g' | awk '{print $3}' | head -n 1`" -o build-pyenv/package/pyenv-virtualenv.tar.gz -O
curl -L -H "Connection: keep-alive" -k "https://github.com`curl -L 'https://github.com/pyenv/pyenv-virtualenv/releases' | sed 's;";\n;g;s;releases/tag;archive/refs/tags;g' | grep '/tags/' | head -n 1`.tar.gz" -o build-pyenv/package/pyenv-virtualenv.tar.gz -O
