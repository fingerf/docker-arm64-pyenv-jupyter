#!/usr/bin/env bash
ping github.com -c 4
ping raw.githubusercontent.com -c 4
curl -L -H "Connection: keep-alive" -k "https://github.com`curl -L 'https://github.com/pyenv/pyenv/releases' | grep '.tar.gz' | sed 's;";  ;g' | awk '{print $3}' | head -n 1`" -o build-pyenv/package/pyenv.tar.gz -O
curl -L -H "Connection: keep-alive" -k "https://github.com`curl -L 'https://github.com/pyenv/pyenv-virtualenv/releases' | grep '.tar.gz' | sed 's;";  ;g' | awk '{print $3}' | head -n 1`" -o build-pyenv/package/pyenv-virtualenv.tar.gz -O
