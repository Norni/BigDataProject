#! /bin/bash

app=gmall
hive=/opt/software/hive-3.1.2/bin/hive

if [ -n "$2" ]
then
    now_date=$2
else
    now_date=`date -d "-1 day" "+%F"`
fi

sql_1="
load data inpath '/origin_data/${app}/db/order_info/$now_date' overwrite into table ${app}.ods_order_info partition(dt='$now_date');
load data inpath '/origin_data/${app}/db/user_info/$now_date' overwrite into table ${app}.ods_user_info partition(dt='$now_date');
load data inpath '/origin_data/${app}/db/coupon_use/$now_date' overwrite into table ${app}.ods_coupon_use partition(dt='$now_date');
load data inpath '/origin_data/${app}/db/order_detail/$now_date' overwrite into table ${app}.ods_order_detail partition(dt='$now_date');
load data inpath '/origin_data/${app}/db/payment_info/$now_date' overwrite into table ${app}.ods_payment_info partition(dt='$now_date');
load data inpath '/origin_data/${app}/db/order_status_log/$now_date' overwrite into table ${app}.ods_order_status_log partition(dt='$now_date');
load data inpath '/origin_data/${app}/db/comment_info/$now_date' overwrite into table ${app}.ods_comment_info partition(dt='$now_date');
load data inpath '/origin_data/${app}/db/order_refund_info/$now_date' overwrite into table ${app}.ods_order_refund_info partition(dt='$now_date');
load data inpath '/origin_data/${app}/db/activity_order/$now_date' overwrite into table ${app}.ods_activity_order partition(dt='$now_date');
load data inpath '/origin_data/${app}/db/sku_info/$now_date' overwrite into table ${app}.ods_sku_info partition(dt='$now_date');
load data inpath '/origin_data/${app}/db/base_category1/$now_date' overwrite into table ${app}.ods_base_category1 partition(dt='$now_date');
load data inpath '/origin_data/${app}/db/base_category2/$now_date' overwrite into table ${app}.ods_base_category2 partition(dt='$now_date');
load data inpath '/origin_data/${app}/db/base_category3/$now_date' overwrite into table ${app}.ods_base_category3 partition(dt='$now_date'); 
load data inpath '/origin_data/${app}/db/base_trademark/$now_date' overwrite into table ${app}.ods_base_trademark partition(dt='$now_date'); 
load data inpath '/origin_data/${app}/db/spu_info/$now_date' overwrite into table ${app}.ods_spu_info partition(dt='$now_date');
load data inpath '/origin_data/${app}/db/cart_info/$now_date' overwrite into table ${app}.ods_cart_info partition(dt='$now_date');
load data inpath '/origin_data/${app}/db/favor_info/$now_date' overwrite into table ${app}.ods_favor_info partition(dt='$now_date');
load data inpath '/origin_data/${app}/db/coupon_info/$now_date' overwrite into table ${app}.ods_coupon_info partition(dt='$now_date');
load data inpath '/origin_data/${app}/db/activity_info/$now_date' overwrite into table ${app}.ods_activity_info partition(dt='$now_date');
load data inpath '/origin_data/${app}/db/activity_rule/$now_date' overwrite into table ${app}.ods_activity_rule partition(dt='$now_date');
load data inpath '/origin_data/${app}/db/activity_sku/$now_date' overwrite into table ${app}.ods_activity_sku partition(dt='$now_date');
load data inpath '/origin_data/${app}/db/base_dic/$now_date' overwrite into table ${app}.ods_base_dic partition(dt='$now_date');
"

sql_2="
load data inpath '/origin_data/${app}/db/base_province/$now_date' overwrite into table ${app}.ods_base_province partition(dt='$now_date');
load data inpath '/origin_data/${app}/db/base_region/$now_date' overwrite into table ${app}.ods_base_region partition(dt='$now_date');
"


case $1 in
"first"){
    $hive -e "$sql_1"
    $hive -e "$sql_2"
};;
"all"){
    $hive -e "$sql_1"
};;
esac
