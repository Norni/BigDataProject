#! /bin/bash

app=gmall
hive=/opt/software/hive-3.1.2/bin/hive

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [ -n "$2" ]
then
    now_date=$2
else
    now_date=`date -d "-1 day" "+%F"`
fi


sql_1="
use gmall;

insert overwrite table ${app}.dwd_start_log partition (dt='$now_date')
select a1.area_code,
       a1.brand,
       a1.channel,
       a1.model,
       a1.mid_id,
       a1.os,
       a1.user_id,
       a1.version_code,
       a1.entry,
       a1.loading_time,
       a1.open_ad_id,
       a1.open_ad_ms,
       a1.open_ad_skip_ms,
       a1.error_code,
       a1.error_msg,
       a1.ts
from (
	 select ParseLogLine_UDF(a.line, 'common', 'ar')             as area_code,
			ParseLogLine_UDF(a.line, 'common', 'ba')             as brand,
			ParseLogLine_UDF(a.line, 'common', 'ch')             as channel,
			ParseLogLine_UDF(a.line, 'common', 'md')             as model,
			ParseLogLine_UDF(a.line, 'common', 'mid')            as mid_id,
			ParseLogLine_UDF(a.line, 'common', 'uid')            as user_id,
			ParseLogLine_UDF(a.line, 'common', 'os')             as os,
			ParseLogLine_UDF(a.line, 'common', 'vc')             as version_code,
			ParseLogLine_UDF(a.line, 'start', 'entry')           as entry,
			ParseLogLine_UDF(a.line, 'start', 'loading_time')    as loading_time,
			ParseLogLine_UDF(a.line, 'start', 'open_ad_id')      as open_ad_id,
			ParseLogLine_UDF(a.line, 'start', 'open_ad_ms')      as open_ad_ms,
			ParseLogLine_UDF(a.line, 'start', 'open_ad_skip_ms') as open_ad_skip_ms,
			ParseLogLine_UDF(a.line, 'err', 'error_code')        as error_code,
			nvl(ParseLogLine_UDF(a.line, 'err', 'msg'), null)    as error_msg,
			nvl(ParseLogLine_UDF(a.line, 'ts'), null)            as ts

	 from ${app}.ods_start_log a
	 where a.dt = '$now_date'
 ) a1
where a1.ts is not null;
"

sql_2="
use gmall;

insert overwrite table ${app}.dwd_page_log partition (dt='$now_date')
select a1.area_code,
       a1.brand,
       a1.channel,
       a1.model,
       a1.mid_id,
       a1.os,
       a1.user_id,
       a1.version_code,
       a1.during_time,
       a1.page_item,
       a1.page_item_type,
       a1.last_page_id,
       a1.page_id,
       a1.source_type,
       a1.error_code,
       a1.error_msg,
       a1.ts

from (
         select ParseLogLine_UDF(a.line, 'common', 'ar')         as area_code,
                ParseLogLine_UDF(a.line, 'common', 'ba')         as brand,
                ParseLogLine_UDF(a.line, 'common', 'ch')         as channel,
                ParseLogLine_UDF(a.line, 'common', 'md')         as model,
                ParseLogLine_UDF(a.line, 'common', 'mid')        as mid_id,
                ParseLogLine_UDF(a.line, 'common', 'os')         as os,
                ParseLogLine_UDF(a.line, 'common', 'uid')        as user_id,
                ParseLogLine_UDF(a.line, 'common', 'vc')         as version_code,
                ParseLogLine_UDF(a.line, 'page', 'during_time')  as during_time,
                ParseLogLine_UDF(a.line, 'page', 'item')         as page_item,
                ParseLogLine_UDF(a.line, 'page', 'item_type')    as page_item_type,
                ParseLogLine_UDF(a.line, 'page', 'last_page_id') as last_page_id,
                ParseLogLine_UDF(a.line, 'page', 'page_id')      as page_id,
                ParseLogLine_UDF(a.line, 'page', 'sourceType')   as source_type,
                ParseLogLine_UDF(a.line, 'err', 'error_code')    as error_code,
                ParseLogLine_UDF(a.line, 'err', 'msg')           as error_msg,
                ParseLogLine_UDF(a.line, 'ts')                   as ts

         from ${app}.ods_event_log a
         where a.dt = '$now_date'
     ) a1
where a1.ts is not null;
"

sql_3="
use gmall;

insert overwrite table ${app}.dwd_action_log partition (dt='$now_date')
select a1.area_code,
       a1.brand,
       a1.channel,
       a1.model,
       a1.mid_id,
       a1.os,
       a1.user_id,
       a1.version_code,
       a1.during_time,
       a1.page_item,
       a1.page_item_type,
       a1.last_page_id,
       a1.page_id,
       a1.source_type,
       get_json_object(actions, '$.action_id') as action_id,
       get_json_object(actions, '$.item')      as item,
       get_json_object(actions, '$.item_type') as item_type,
       get_json_object(actions, '$.ts')        as action_ts,
       a1.error_code,
       a1.error_msg,
       a1.ts
from (
         select ParseLogLine_UDF(a.line, 'common', 'ar')         as area_code,
                ParseLogLine_UDF(a.line, 'common', 'ba')         as brand,
                ParseLogLine_UDF(a.line, 'common', 'ch')         as channel,
                ParseLogLine_UDF(a.line, 'common', 'md')         as model,
                ParseLogLine_UDF(a.line, 'common', 'mid')        as mid_id,
                ParseLogLine_UDF(a.line, 'common', 'os')         as os,
                ParseLogLine_UDF(a.line, 'common', 'uid')        as user_id,
                ParseLogLine_UDF(a.line, 'common', 'vc')         as version_code,
                ParseLogLine_UDF(a.line, 'page', 'during_time')  as during_time,
                ParseLogLine_UDF(a.line, 'page', 'item')         as page_item,
                ParseLogLine_UDF(a.line, 'page', 'item_type')    as page_item_type,
                ParseLogLine_UDF(a.line, 'page', 'last_page_id') as last_page_id,
                ParseLogLine_UDF(a.line, 'page', 'page_id')      as page_id,
                ParseLogLine_UDF(a.line, 'page', 'sourceType')   as source_type,
                ParseLogLine_UDF(a.line, 'actions')              as actions_json,
                ParseLogLine_UDF(a.line, 'err', 'error_code')    as error_code,
                ParseLogLine_UDF(a.line, 'err', 'msg')           as error_msg,
                ParseLogLine_UDF(a.line, 'ts')                   as ts

         from ${app}.ods_event_log a
         where a.dt = '$now_date'
) a1 lateral view get_json_array(a1.actions_json) tmp as actions
where a1.ts is not null
and a1.actions_json is not null;
"

sql_4="
use gmall;

insert overwrite table ${app}.dwd_display_log partition (dt='$now_date')
select a1.area_code,
       a1.brand,
       a1.channel,
       a1.model,
       a1.mid_id,
       a1.os,
       a1.user_id,
       a1.version_code,
       a1.during_time,
       a1.page_item,
       a1.page_item_type,
       a1.last_page_id,
       a1.page_id,
       a1.source_type,
       get_json_object(displays, '$.display_type')    as display_type,
       get_json_object(displays, '$.item')         as item,
       get_json_object(displays, '$.item_type')    as item_type,
       get_json_object(displays, '$.order')           as seq,
       a1.error_code,
       a1.error_msg,
       a1.ts
from (
         select ParseLogLine_UDF(a.line, 'common', 'ar')         as area_code,
                ParseLogLine_UDF(a.line, 'common', 'ba')         as brand,
                ParseLogLine_UDF(a.line, 'common', 'ch')         as channel,
                ParseLogLine_UDF(a.line, 'common', 'md')         as model,
                ParseLogLine_UDF(a.line, 'common', 'mid')        as mid_id,
                ParseLogLine_UDF(a.line, 'common', 'os')         as os,
                ParseLogLine_UDF(a.line, 'common', 'uid')        as user_id,
                ParseLogLine_UDF(a.line, 'common', 'vc')         as version_code,
                ParseLogLine_UDF(a.line, 'page', 'during_time')  as during_time,
                ParseLogLine_UDF(a.line, 'page', 'item')         as page_item,
                ParseLogLine_UDF(a.line, 'page', 'item_type')    as page_item_type,
                ParseLogLine_UDF(a.line, 'page', 'last_page_id') as last_page_id,
                ParseLogLine_UDF(a.line, 'page', 'page_id')      as page_id,
                ParseLogLine_UDF(a.line, 'page', 'sourceType')   as source_type,
                ParseLogLine_UDF(a.line, 'displays')             as displays_json,
                ParseLogLine_UDF(a.line, 'err', 'error_code')    as error_code,
                ParseLogLine_UDF(a.line, 'err', 'msg')           as error_msg,
                ParseLogLine_UDF(a.line, 'ts')                   as ts

         from ${app}.ods_event_log a
         where a.dt = '$now_date'
     ) a1 lateral view get_json_array(a1.displays_json) tmp as displays
where a1.ts is not null
and a1.displays_json is not null;
"



case $1 in
"all"){
    $hive -e "$sql_1"
    $hive -e "$sql_2"
    $hive -e "$sql_3"
    $hive -e "$sql_4"
};;
"dwd_start_log"){
    $hive -e "$sql_1"
};;
"dwd_page_log"){
    $hive -e "$sql_2"
};;
"dwd_action_log"){
    $hive -e "$sql_3"
};;
"dwd_display_log"){
    $hive -e "$sql_4"
};;
*){
	echo "tips:  dwd_start_log|dwd_page_log|dwd_action_log|dwd_display_log|all '$now_date'"
};;
esac