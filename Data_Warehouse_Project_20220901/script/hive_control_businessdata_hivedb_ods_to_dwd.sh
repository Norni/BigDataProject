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
use ${app};


-- 1. 商品维度表 全量
insert overwrite table ${app}.dwd_dim_sku_info partition (dt='$now_date')
select a.id,
       a.spu_id,
       a.price,
       a.sku_name,
       a.sku_desc,
       a.weight,
       a.tm_id,
       b.tm_name,
       a.category3_id,
       d.category2_id,
       e.category1_id,
       d.name as category3_name,
       e.name as category2_name,
       f.name as category1_name,
       c.spu_name,
       a.create_time

from ods_sku_info a
inner join ods_base_trademark b
on b.tm_id = a.tm_id
and b.dt = a.dt
inner join ods_spu_info c
on c.id = a.spu_id
and c.dt = a.dt
inner join ods_base_category3 d
on d.id = a.category3_id
and d.dt = a.dt
inner join ods_base_category2 e
on e.id = d.category2_id
and e.dt = a.dt
inner join ods_base_category1 f
on f.id = e.category1_id
and f.dt = a.dt

where a.dt = '$now_date';

-- 2. 优惠卷维度表 全量

insert overwrite table ${app}.dwd_dim_coupon_info partition(dt='$now_date')
select
    id,
    coupon_name,
    coupon_type,
    condition_amount,
    condition_num,
    activity_id,
    benefit_amount,
    benefit_discount,
    create_time,
    range_type,
    spu_id,
    tm_id,
    category3_id,
    limit_num,
    operate_time,
    expire_time
from ods_coupon_info
where dt='$now_date';

-- 3. 活动维度表 全量

insert overwrite table ${app}.dwd_dim_activity_info partition(dt='$now_date')
select
    id,
    activity_name,
    activity_type,
    start_time,
    end_time,
    create_time
from ods_activity_info
where dt='$now_date';


-- 6. 支付事实表  事务型事实表

insert overwrite table dwd_fact_payment_info partition(dt='$now_date')
select a.id,
       a.out_trade_no,
       a.order_id,
       a.user_id,
       a.alipay_trade_no,
       a.total_amount as payment_amount,
       a.subject,
       a.payment_type,
       a.payment_time,
       b.province_id

from ods_payment_info a
inner join ods_order_info b
on b.id = a.order_id
and b.dt = a.dt
where a.dt = '$now_date';


-- 7. 退款事实表  事务型事实表

insert overwrite table dwd_fact_order_refund_info partition(dt='$now_date')
select
    id,
    user_id,
    order_id,
    sku_id,
    refund_type,
    refund_num,
    refund_amount,
    refund_reason_type,
    create_time
from ods_order_refund_info
where dt='$now_date';

-- 8. 评价事实表  事务型事实表

insert overwrite table dwd_fact_comment_info partition(dt='$now_date')
select
    id,
    user_id,
    sku_id,
    spu_id,
    order_id,
    appraise,
    create_time
from ods_comment_info
where dt='$now_date';

-- 9. 订单明显事实表  事务型事实表

insert overwrite table dwd_fact_order_detail partition(dt='$now_date')
select
    id,
    order_id,
    user_id,
    sku_id,
    sku_name,
    order_price,
    sku_num,
    create_time,
    province_id,
    source_type,
    source_id,
    original_amount_d,
    if(rn=1,final_total_amount -(sum_div_final_amount - final_amount_d),final_amount_d),
    if(rn=1,feight_fee - (sum_div_feight_fee - feight_fee_d),feight_fee_d),
    if(rn=1,benefit_reduce_amount - (sum_div_benefit_reduce_amount -benefit_reduce_amount_d), benefit_reduce_amount_d)
from
(
    select od.id,
            od.order_id,
            oi.user_id,
            od.sku_id,
            od.sku_name,
            od.order_price,
            od.sku_num,
            od.create_time,
            oi.province_id,
            od.source_type,
            od.source_id,
        round(od.order_price*od.sku_num,2) original_amount_d,
        round(od.order_price*od.sku_num/oi.original_total_amount*oi.final_total_amount,2) final_amount_d,
        round(od.order_price*od.sku_num/oi.original_total_amount*oi.feight_fee,2) feight_fee_d,
        round(od.order_price*od.sku_num/oi.original_total_amount*oi.benefit_reduce_amount,2) benefit_reduce_amount_d,
        row_number() over(partition by od.order_id order by od.id desc) rn,
        oi.final_total_amount,
        oi.feight_fee,
        oi.benefit_reduce_amount,
        sum(round(od.order_price*od.sku_num/oi.original_total_amount*oi.final_total_amount,2)) over(partition by od.order_id) sum_div_final_amount,
        sum(round(od.order_price*od.sku_num/oi.original_total_amount*oi.feight_fee,2)) over(partition by od.order_id) sum_div_feight_fee,
        sum(round(od.order_price*od.sku_num/oi.original_total_amount*oi.benefit_reduce_amount,2)) over(partition by od.order_id) sum_div_benefit_reduce_amount
    from ods_order_detail od
    inner join ods_order_info oi
    on od.order_id=oi.id
    and oi.dt = od.dt
    where od.dt = '$now_date'
)t1;


-- 10. 加购事实表

insert overwrite table dwd_fact_cart_info partition(dt='$now_date')
select
    id,
    user_id,
    sku_id,
    cart_price,
    sku_num,
    sku_name,
    create_time,
    operate_time,
    is_ordered,
    order_time,
    source_type,
    source_id
from ods_cart_info
where dt='$now_date';

-- 11. 收藏事实表

insert overwrite table dwd_fact_favor_info partition(dt='$now_date')
select
    id,
    user_id,
    sku_id,
    spu_id,
    is_cancel,
    create_time,
    cancel_time
from ods_favor_info
where dt='$now_date';


-- 12. 优惠卷领用事实表

insert overwrite table dwd_fact_coupon_use
select
    if(new.id is null,old.id,new.id),
    if(new.coupon_id is null,old.coupon_id,new.coupon_id),
    if(new.user_id is null,old.user_id,new.user_id),
    if(new.order_id is null,old.order_id,new.order_id),
    if(new.coupon_status is null,old.coupon_status,new.coupon_status),
    if(new.get_time is null,old.get_time,new.get_time),
    if(new.using_time is null,old.using_time,new.using_time),
    if(new.used_time is null,old.used_time,new.used_time),
    date_format(if(new.get_time is null,old.get_time,new.get_time),'yyyy-MM-dd')
from
(
    select
        id,
        coupon_id,
        user_id,
        order_id,
        coupon_status,
        get_time,
        using_time,
        used_time
    from dwd_fact_coupon_use
    where dt in
    (
        select
            date_format(get_time,'yyyy-MM-dd')
        from ods_coupon_use
        where dt='$now_date'
    )
)old
full outer join
(
    select
        id,
        coupon_id,
        user_id,
        order_id,
        coupon_status,
        get_time,
        using_time,
        used_time
    from ods_coupon_use
    where dt='$now_date'
)new
on old.id=new.id;


-- 13. 订单事实表

insert overwrite table dwd_fact_order_info
select
    if(new.id is null,old.id,new.id),
    if(new.order_status is null,old.order_status,new.order_status),
    if(new.user_id is null,old.user_id,new.user_id),
    if(new.out_trade_no is null,old.out_trade_no,new.out_trade_no),
    if(new.tms['1001'] is null,old.create_time,new.tms['1001']),--1001对应未支付状态
    if(new.tms['1002'] is null,old.payment_time,new.tms['1002']),
    if(new.tms['1003'] is null,old.cancel_time,new.tms['1003']),
    if(new.tms['1004'] is null,old.finish_time,new.tms['1004']),
    if(new.tms['1005'] is null,old.refund_time,new.tms['1005']),
    if(new.tms['1006'] is null,old.refund_finish_time,new.tms['1006']),
    if(new.province_id is null,old.province_id,new.province_id),
    if(new.activity_id is null,old.activity_id,new.activity_id),
    if(new.original_total_amount is null,old.original_total_amount,new.original_total_amount),
    if(new.benefit_reduce_amount is null,old.benefit_reduce_amount,new.benefit_reduce_amount),
    if(new.feight_fee is null,old.feight_fee,new.feight_fee),
    if(new.final_total_amount is null,old.final_total_amount,new.final_total_amount),
    date_format(if(new.tms['1001'] is null,old.create_time,new.tms['1001']),'yyyy-MM-dd')
from
(
    select
        id,
        order_status,
        user_id,
        out_trade_no,
        create_time,
        payment_time,
        cancel_time,
        finish_time,
        refund_time,
        refund_finish_time,
        province_id,
        activity_id,
        original_total_amount,
        benefit_reduce_amount,
        feight_fee,
        final_total_amount
    from dwd_fact_order_info
    where dt
    in
    (
        select
          date_format(create_time,'yyyy-MM-dd')
        from ods_order_info
        where dt='$now_date'
    )
)old
full outer join
(
    select
        info.id,
        info.order_status,
        info.user_id,
        info.out_trade_no,
        info.province_id,
        act.activity_id,
        log.tms,
        info.original_total_amount,
        info.benefit_reduce_amount,
        info.feight_fee,
        info.final_total_amount
    from
    (
        select
            order_id,
            str_to_map(concat_ws(',',collect_set(concat(order_status,'=',operate_time))),',','=') tms
        from ods_order_status_log
        where dt='$now_date'
        group by order_id
    )log
    join
    (
        select * from ods_order_info where dt='$now_date'
    )info
    on log.order_id=info.id
    left join
    (
        select * from ods_activity_order where dt='$now_date'
    )act
    on log.order_id=act.order_id
)new
on old.id=new.id;

"

sql_2="
use ${app};

-- 4. 地区维度表 特殊

insert overwrite table dwd_dim_base_province
select a.id,
       a.name,
       a.area_code,
       a.iso_code,
       a.region_id,
       b.region_name
from ods_base_province a
inner join ods_base_region b
on b.id = a.region_id;
"

sql_3="
use ${app};

-- 14. 用户维度表 拉链表

insert overwrite table dwd_dim_user_info_his_tmp
select *
from (
         select id,
                name,
                birthday,
                gender,
                email,
                user_level,
                create_time,
                operate_time,
                '$now_date' start_date,
                '9999-99-99' end_date
         from ods_user_info
         where dt = '$now_date'

         union all
         select uh.id,
                uh.name,
                uh.birthday,
                uh.gender,
                uh.email,
                uh.user_level,
                uh.create_time,
                uh.operate_time,
                uh.start_date,
                if(ui.id is not null and uh.end_date = '9999-99-99', date_add(ui.dt, -1), uh.end_date) end_date
         from dwd_dim_user_info_his uh
                  left join
              (
                  select *
                  from ods_user_info
                  where dt = '$now_date'
              ) ui on uh.id = ui.id
     ) his
order by his.id, start_date;


insert overwrite table dwd_dim_user_info_his 
select * from dwd_dim_user_info_his_tmp;
"


case $1 in
"first"){
    $hive -e "$sql_1 $sql_2"
};;
"all"){
    $hive -e "$sql_1 $sql_3"
};;
*){
    echo "tips: $0 first|all $now_date";
};;
esac
