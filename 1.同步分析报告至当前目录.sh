#!/bin/bash
set -u

: ${DIALOG=dialog}
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}

: ${SIG_HUP=1}
: ${SIG_INT=2}
: ${SIG_QUIT=3}
: ${SIG_KILL=9}
: ${SIG_TERM=15}

dir_src="../WH投资数据分析系统-Dev开发环境/Runtime/Analyse"
dir_des="Analyse分析报告"
if [[ ! -d $dir_src ]];then
    $DIALOG --title "WH投资数据分析系统" --clear \
        --msgbox "请检查: $dir_src 是否存在!" 10 41
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
