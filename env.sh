#!/bin/bash

#set -e

# 在此之前先安装 anaconda 环境

ANACONDA_BASE='/opt/anaconda/'                                          # anaconda 环境家目录

CUR_DIR=$(dirname $(realpath -- $0))
ANACONDA_ENV_NAME='spider'
ANACONDA_ACTIVATE="${ANACONDA_BASE}/bin/activate"
ANACONDA_DEACTIVATE="${ANACONDA_BASE}/bin/deactivate" 

SPIDER_RUNTIME="${CUR_DIR}/runtime"

function cleanup()
{
    conda deactivate > /dev/null 2>&1
    conda deactivate > /dev/null 2>&1
    echo "exit anaconda!" && exit
}

#trap cleanup SIGQUIT SIGCHLD SIGINT SIGTERM SIGABRT SIGKILL

echo "Current directory is $CUR_DIR"
[[ -d ${SPIDER_RUNTIME} ]] && mkdir -p ${SPIDER_RUNTIME}
cp "${CUR_DIR}/data/.condarc" "/home/$(whoami)/"

source "${ANACONDA_BASE}/etc/profile.d/conda.sh" || return $?

# 如果是第一次换源则要打开
#sudo conda clean -i
#sudo conda update conda

# 配置 spider 环境
conda env list | grep "${ANACONDA_ENV_NAME}" > /dev/null 2>&1
[[ 0 -ne $? ]] && conda env create --prefix "${SPIDER_RUNTIME}/${ANACONDA_ENV_NAME}" -f ${CUR_DIR}/data/${ANACONDA_ENV_NAME}.yml

source ${ANACONDA_ACTIVATE} ${SPIDER_RUNTIME}/${ANACONDA_ENV_NAME}

echo "Active conda environment ${SPIDER_RUNTIME}/${ANACONDA_ENV_NAME}"
conda activate ${SPIDER_RUNTIME}/${ANACONDA_ENV_NAME}
${CUR_DIR}/main.py

#conda deactivate "${ANACONDA_ENV_NAME}"







