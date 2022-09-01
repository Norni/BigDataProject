#! /bin/bash

app=gmall
hive=/opt/software/hive-3.1.2/bin/hive

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [ -n "$1" ]
then
    now_date=$1
else
    now_date=`date -d "-1 day" "+%F"`
fi


sql="
use gmall;


-- 1. 每日设备行为

with tmp_start as (
    select a.mid_id,
           a.brand,
           a.model,
           count(*) as login_count
    from dwd_start_log a
    where a.dt='$now_date'
    group by a.mid_id,a.brand,a.model
),
tmp_page as (
    select tmp.mid_id,
           tmp.brand,
           tmp.model,
           collect_set(named_struct('page_id',page_id,'page_count',page_count)) as page_stats
    from (
         select a.mid_id,
                a.brand,
                a.model,
                a.page_id,
                count(*) as page_count
         from dwd_page_log a
         where a.dt = '$now_date'
         group by a.mid_id, a.brand, a.model, a.page_id
     )tmp
    group by tmp.mid_id,tmp.brand,tmp.model
)
insert overwrite table dws_uv_detail_daycount partition (dt='$now_date')
select nvl(tmp_start.mid_id,tmp_page.mid_id) as mid_id,
       nvl(tmp_start.brand,tmp_page.brand) as brand,
       nvl(tmp_start.model,tmp_page.model) as model,
       tmp_start.login_count,
       tmp_page.page_stats
from tmp_start
full outer join tmp_page
on tmp_page.mid_id = tmp_start.mid_id
and tmp_page.brand = tmp_start.brand
and tmp_page.model = tmp_start.model;


-- 2. 每日会员行为

with tmp_login as
         (
             select user_id,
                    count(*) login_count
             from dwd_start_log
             where dt = '$now_date'
               and user_id is not null
             group by user_id
         ),
     tmp_cart as
         (
             select user_id,
                    count(*) cart_count
             from dwd_action_log
             where dt = '$now_date'
               and user_id is not null
               and action_id = 'cart_add'
             group by user_id
         ),
     tmp_order as
         (
             select user_id,
                    count(*)                order_count,
                    sum(final_total_amount) order_amount
             from dwd_fact_order_info
             where dt = '$now_date'
             group by user_id
         ),
     tmp_payment as
         (
             select user_id,
                    count(*)   as payment_count,
                    sum(payment_amount) as payment_amount
             from dwd_fact_payment_info
             where dt = '$now_date'
             group by user_id
         ),
     tmp_order_detail as
         (
             select user_id,
                    collect_set(named_struct('sku_id', sku_id, 'sku_num', sku_num, 'order_count', order_count,
                                             'order_amount', order_amount)) order_stats
             from (
                      select user_id,
                             sku_id,
                             sum(sku_num)                                sku_num,
                             count(*)                                    order_count,
                             cast(sum(final_amount_d) as decimal(20, 2)) order_amount
                      from dwd_fact_order_detail
                      where dt = '$now_date'
                      group by user_id, sku_id
                  ) tmp
             group by user_id
         )

insert overwrite table dws_user_action_daycount partition (dt = '$now_date')
select tmp_login.user_id,
       login_count,
       nvl(cart_count, 0),
       nvl(order_count, 0),
       nvl(order_amount, 0.0),
       nvl(payment_count, 0),
       nvl(payment_amount, 0.0),
       order_stats
from tmp_login
left join tmp_cart on tmp_login.user_id = tmp_cart.user_id
left join tmp_order on tmp_login.user_id = tmp_order.user_id
left join tmp_payment on tmp_login.user_id = tmp_payment.user_id
left join tmp_order_detail on tmp_login.user_id = tmp_order_detail.user_id;


-- 3. 每日商品行为
with tmp_order as
(
    select
        sku_id,
        count(*) order_count,
        sum(sku_num) order_num,
        sum(final_amount_d) order_amount
    from dwd_fact_order_detail
    where dt='$now_date'
    group by sku_id
),
tmp_payment as
(
    select
        sku_id,
        count(*) payment_count,
        sum(sku_num) payment_num,
        sum(final_amount_d) payment_amount
    from dwd_fact_order_detail
    where (dt='$now_date'
    or dt=date_add('$now_date',-1))
    and order_id in
    (
        select
            id
        from dwd_fact_order_info
        where (dt='$now_date'
        or dt=date_add('$now_date',-1))
        and date_format(payment_time,'yyyy-MM-dd')='$now_date'
    )
    group by sku_id
),
tmp_refund as
(
    select
        sku_id,
        count(*) refund_count,
        sum(refund_num) refund_num,
        sum(refund_amount) refund_amount
    from dwd_fact_order_refund_info
    where dt='$now_date'
    group by sku_id
),
tmp_cart as
(
    select item sku_id,
        count(*) cart_count
    from dwd_action_log
    where dt='$now_date'
    and user_id is not null
    and action_id='cart_add'
    group by item
),tmp_favor as
(
    select
        item sku_id,
        count(*) favor_count
    from dwd_action_log
    where dt='$now_date'
    and user_id is not null
    and action_id='favor_add'
    group by item
),
tmp_appraise as
(
select
    sku_id,
    sum(if(appraise='1201',1,0)) appraise_good_count,
    sum(if(appraise='1202',1,0)) appraise_mid_count,
    sum(if(appraise='1203',1,0)) appraise_bad_count,
    sum(if(appraise='1204',1,0)) appraise_default_count
from dwd_fact_comment_info
where dt='$now_date'
group by sku_id
)

-- 注意：如果是23点59下单，支付日期跨天。需要从订单详情里面取出支付时间是今天，且订单时间是昨天或者今天的订单。
insert overwrite table dws_sku_action_daycount partition(dt='$now_date')
select
    sku_id,
    sum(order_count),
    sum(order_num),
    sum(order_amount),
    sum(payment_count),
    sum(payment_num),
    sum(payment_amount),
    sum(refund_count),
    sum(refund_num),
    sum(refund_amount),
    sum(cart_count),
    sum(favor_count),
    sum(appraise_good_count),
    sum(appraise_mid_count),
    sum(appraise_bad_count),
    sum(appraise_default_count)
from
(
    select
        sku_id,
        order_count,
        order_num,
        order_amount,
        0 payment_count,
        0 payment_num,
        0 payment_amount,
        0 refund_count,
        0 refund_num,
        0 refund_amount,
        0 cart_count,
        0 favor_count,
        0 appraise_good_count,
        0 appraise_mid_count,
        0 appraise_bad_count,
        0 appraise_default_count
    from tmp_order
    union all
    select
        sku_id,
        0 order_count,
        0 order_num,
        0 order_amount,
        payment_count,
        payment_num,
        payment_amount,
        0 refund_count,
        0 refund_num,
        0 refund_amount,
        0 cart_count,
        0 favor_count,
        0 appraise_good_count,
        0 appraise_mid_count,
        0 appraise_bad_count,
        0 appraise_default_count
    from tmp_payment
    union all
    select
        sku_id,
        0 order_count,
        0 order_num,
        0 order_amount,
        0 payment_count,
        0 payment_num,
        0 payment_amount,
        refund_count,
        refund_num,
        refund_amount,
        0 cart_count,
        0 favor_count,
        0 appraise_good_count,
        0 appraise_mid_count,
        0 appraise_bad_count,
        0 appraise_default_count
    from tmp_refund
    union all
    select
        sku_id,
        0 order_count,
        0 order_num,
        0 order_amount,
        0 payment_count,
        0 payment_num,
        0 payment_amount,
        0 refund_count,
        0 refund_num,
        0 refund_amount,
        cart_count,
        0 favor_count,
        0 appraise_good_count,
        0 appraise_mid_count,
        0 appraise_bad_count,
        0 appraise_default_count
    from tmp_cart
    union all
    select
        sku_id,
        0 order_count,
        0 order_num,
        0 order_amount,
        0 payment_count,
        0 payment_num,
        0 payment_amount,
        0 refund_count,
        0 refund_num,
        0 refund_amount,
        0 cart_count,
        favor_count,
        0 appraise_good_count,
        0 appraise_mid_count,
        0 appraise_bad_count,
        0 appraise_default_count
    from tmp_favor
    union all
    select
        sku_id,
        0 order_count,
        0 order_num,
        0 order_amount,
        0 payment_count,
        0 payment_num,
        0 payment_amount,
        0 refund_count,
        0 refund_num,
        0 refund_amount,
        0 cart_count,
        0 favor_count,
        appraise_good_count,
        appraise_mid_count,
        appraise_bad_count,
        appraise_default_count
    from tmp_appraise
)tmp
group by sku_id;


-- 4. 每日活动统计

with tmp_op as
(
    select
        activity_id,
        sum(if(date_format(create_time,'yyyy-MM-dd')='$now_date',1,0)) order_count,
        sum(if(date_format(create_time,'yyyy-MM-dd')='$now_date',final_total_amount,0)) order_amount,
        sum(if(date_format(payment_time,'yyyy-MM-dd')='$now_date',1,0)) payment_count,
        sum(if(date_format(payment_time,'yyyy-MM-dd')='$now_date',final_total_amount,0)) payment_amount
    from dwd_fact_order_info
    where (dt='$now_date' or dt=date_add('$now_date',-1))
    and activity_id is not null
    group by activity_id
),
tmp_display as
(
    select
        item activity_id,
        count(*) display_count
    from dwd_display_log
    where dt='$now_date'
    and item_type='activity_id'
    group by item
),
tmp_activity as
(
    select
        *
    from dwd_dim_activity_info
    where dt='$now_date'
)
insert overwrite table dws_activity_info_daycount partition(dt='$now_date')
select
    nvl(tmp_op.activity_id,tmp_display.activity_id),
    tmp_activity.activity_name,
    tmp_activity.activity_type,
    tmp_activity.start_time,
    tmp_activity.end_time,
    tmp_activity.create_time,
    tmp_display.display_count,
    tmp_op.order_count,
    tmp_op.order_amount,
    tmp_op.payment_count,
    tmp_op.payment_amount
from tmp_op
full outer join tmp_display on tmp_op.activity_id=tmp_display.activity_id
left join tmp_activity on nvl(tmp_op.activity_id,tmp_display.activity_id)=tmp_activity.id;



-- 5. 每日地区统计

with tmp_login as
(
    select
        area_code,
        count(*) login_count
    from dwd_start_log
    where dt='$now_date'
    group by area_code
),
tmp_op as
(
    select
        province_id,
        sum(if(date_format(create_time,'yyyy-MM-dd')='$now_date',1,0)) order_count,
        sum(if(date_format(create_time,'yyyy-MM-dd')='$now_date',final_total_amount,0)) order_amount,
        sum(if(date_format(payment_time,'yyyy-MM-dd')='$now_date',1,0)) payment_count,
        sum(if(date_format(payment_time,'yyyy-MM-dd')='$now_date',final_total_amount,0)) payment_amount
    from dwd_fact_order_info
    where (dt='$now_date' or dt=date_add('$now_date',-1))
    group by province_id
)
insert overwrite table dws_area_stats_daycount partition(dt='$now_date')
select
    pro.id,
    pro.province_name,
    pro.area_code,
    pro.iso_code,
    pro.region_id,
    pro.region_name,
    nvl(tmp_login.login_count,0),
    nvl(tmp_op.order_count,0),
    nvl(tmp_op.order_amount,0.0),
    nvl(tmp_op.payment_count,0),
    nvl(tmp_op.payment_amount,0.0)
from dwd_dim_base_province pro
left join tmp_login on pro.area_code=tmp_login.area_code
left join tmp_op on pro.id=tmp_op.province_id;


"


$hive -e "$sql"
