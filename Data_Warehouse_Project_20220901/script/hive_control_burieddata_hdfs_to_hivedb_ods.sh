#! /bin/bash

app=gmall
hive=/opt/software/hive-3.1.2/bin/hive

if [ -n "$1" ]
then
    now_date=$1
else
    now_date=`date -d "-1 day" "+%F"`
fi

echo ">>>---日志日期为 $now_date"
sql="
load data inpath '/origin_data/gmall/log/topic_start/$now_date' overwrite into table ${app}.ods_start_log partition (dt='$now_date');
load data inpath '/origin_data/gmall/log/topic_event/$now_date' overwrite into table ${app}.ods_event_log partition (dt='$now_date');
"

$hive -e "$sql"
echo ">>>---导入完成"
