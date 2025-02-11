#!/bin/bash
dir_src="../WH投资数据分析系统-Dev开发环境/Runtime/Analyse"
dir_des="Analyse分析报告"
if [[ ! -d $dir_src ]];then
    echo -e "\033[31m 请检查 $dir_src 是否存在!\033[0m"
    exit 1
fi
if [[ ! -d $dir_des ]];then
    mkdir -p $dir_des
fi
for subdir in $dir_src/*;do
    if [[ ! -d $subdir ]];then
        continue
    fi
    rsync -aqP --delete $subdir $dir_des
    echo -e "\033[36m 同步 $subdir 至 $dir_des  完毕!\033[0m"
done
