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

name_analyse="Analyse分析报告"
if [[ ! -d $name_analyse ]];then
    $DIALOG --title "数据同步工具" --clear \
        --msgbox "请检查 $name_analyse 是否存在!" 10 41
    exit 1
fi
subfolders=()
while IFS= read -r -d '' folder; do
    subfolders+=("$folder")
done < <(find "$name_analyse" -maxdepth 1 -type d -not -path "$name_analyse" -print0)

if [[ ${#subfolders[@]} -eq 0 ]]; then
    $DIALOG --title "WH投资数据分析系统" --clear \
        --msgbox "目标文件夹 $name_analyse 中没有子文件夹。" 10 41
    exit 1
fi

OPTIONS=()
for dir in "${subfolders[@]}"; do
    folder_size=$(du -sh "$dir" | awk '{print $1}')
    t_name=$(basename $dir)
    OPTIONS+=("$t_name" "$folder_size" off)
done

tempfile=$(mktemp /tmp/test.XXXXXX)
trap "rm -f $tempfile" 0 $SIG_HUP $SIG_INT $SIG_QUIT $SIG_TERM
$DIALOG --title "管理Analyse分析文件" --checklist "请选择删除的分析数据：" 20 60 10 "${OPTIONS[@]}" 2> $tempfile
retval=$?
case $retval in
    $DIALOG_OK)
        process=`cat $tempfile`
        IFS=' ' #setting space as delimiter
        read -ra processes<<<"$process" #reading str as an array as tokens separated by IFS
        ;;
    $DIALOG_CANCEL)
        echo "Cancel pressed."
        ;;
    $DIALOG_HELP)
        echo "Help pressed: `cat $tempfile`"
        ;;
    $DIALOG_EXTRA)
        echo "Extra button pressed."
        ;;
    $DIALOG_ITEM_HELP)
        echo "Item-help button pressed: `cat $tempfile`"
        ;;
    $DIALOG_ESC)
        if test -s $tempfile ; then
            cat $tempfile
        else
            echo "ESC pressed."
        fi
        exit;;
esac

if [[ ${#processes[@]} -eq 0 ]]; then
    echo " 未选择任何选项"
    exit 1
fi

for part in "${processes[@]}"; do
    d_name="$name_analyse/$part"
    if [[ ! -d $d_name ]];then
        echo " 请检查 $d_name 是否存在!"
        continue
    fi
    rm -rf $d_name
    echo " 删除 $d_name 完毕!"
done
