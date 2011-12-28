#!/bin/bash
export PERLBREW_ROOT=~/perl5/perlbrew
export PERLBREW_HOME=~/.perlbrew
source ${PERLBREW_ROOT}/etc/bashrc
exec start_server --port=6666 --pid-file=/home/takuji/var/run/site.pid -- plackup -I ./lib -s Starlet -E deployment --interval 2 --workers 10 -a app.psgi
