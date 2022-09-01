use gmall;


-- 1 ods_order_info  订单表  增量及更新
drop table if exists ods_order_info;
create external table ods_order_info (
  `id` string COMMENT '编号',
  `consignee` string COMMENT '收货人',
  `consignee_tel` string COMMENT '收件人电话',
  `final_total_amount` decimal(16,2) COMMENT '总金额',
  `order_status` string COMMENT '订单状态',
  `user_id` string COMMENT '用户id',
  `delivery_address` string COMMENT '送货地址',
  `order_comment` string COMMENT '订单备注',
  `out_trade_no` string COMMENT '订单交易编号（第三方支付用)',
  `trade_body` string COMMENT '订单描述(第三方支付用)',
  `create_time` string COMMENT '创建时间',
  `operate_time` string COMMENT '操作时间',
  `expire_time` string COMMENT '失效时间',
  `tracking_no` string COMMENT '物流单编号',
  `parent_order_id` string COMMENT '父订单编号',
  `img_url` string COMMENT '图片路径',
  `province_id` string COMMENT '地区',
  `benefit_reduce_amount` decimal(16,2) COMMENT '优惠金额',
  `original_total_amount` decimal(16,2) COMMENT '原价金额',
  `feight_fee` decimal(16,2) COMMENT '运费'
) comment '订单表'
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_order_info/';

-- 2 ods_user_info 用户表  增量及更新
drop table if exists ods_user_info;
create external table ods_user_info(
  `id` string COMMENT '编号',
  `login_name` string COMMENT '用户名称',
  `nick_name` string COMMENT '用户昵称',
  `passwd` string COMMENT '用户密码',
  `name` string COMMENT '用户姓名',
  `phone_num` string COMMENT '手机号',
  `email` string COMMENT '邮箱',
  `head_img` string COMMENT '头像',
  `user_level` string COMMENT '用户级别',
  `birthday` string COMMENT '用户生日',
  `gender` string COMMENT '性别 M男,F女',
  `create_time` string COMMENT '创建时间',
  `operate_time` string COMMENT '修改时间'
)
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_user_info/';

-- 3 ods_coupon_use 优惠券领用表  新增及变化
drop table if exists ods_coupon_use;
create external table ods_coupon_use(
  `id` string COMMENT '编号',
  `coupon_id` string COMMENT '购物券ID',
  `user_id` string COMMENT '用户ID',
  `order_id` string COMMENT '订单ID',
  `coupon_status` string COMMENT '购物券状态',
  `get_time` string COMMENT '领券时间',
  `using_time` string COMMENT '使用时间',
  `used_time` string COMMENT '支付时间',
  `expire_time` string COMMENT '过期时间'
)
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_coupon_use/';

-- 4 ods_order_detail  订单详情表  增量
drop table if exists ods_order_detail;
create external table ods_order_detail(
  `id` string COMMENT '编号',
  `order_id` string COMMENT '订单编号',
  `sku_id` string COMMENT 'sku_id',
  `sku_name` string COMMENT 'sku名称（冗余)',
  `img_url` string COMMENT '图片名称（冗余)',
  `order_price` decimal(10,2)  COMMENT '购买价格(下单时sku价格）',
  `sku_num` string COMMENT '购买个数',
  `create_time` string COMMENT '创建时间',
  `source_type` string COMMENT '来源类型',
  `source_id` string COMMENT '来源编号'
)
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_order_detail/';

-- 5 ods_payment_info 支付流水表  增量
drop table if exists ods_payment_info;
create external table ods_payment_info(
  `id` string COMMENT '编号',
  `out_trade_no` string COMMENT '对外业务编号',
  `order_id` string COMMENT '订单编号',
  `user_id` string COMMENT '用户编号',
  `alipay_trade_no` string COMMENT '支付宝交易流水编号',
  `total_amount` decimal(16,2) COMMENT '支付金额',
  `subject` string COMMENT '交易内容',
  `payment_type` string COMMENT '支付方式',
  `payment_time` string COMMENT '支付时间'
)
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_payment_info/';

-- 6	ods_order_status_log	订单状态表	增量
drop table if exists ods_order_status_log;
create external table ods_order_status_log(
    `id`   bigint COMMENT '编号',
    `order_id` string COMMENT '订单ID',
    `order_status` string COMMENT '订单状态',
    `operate_time` string COMMENT '修改时间'
)  COMMENT '订单状态表'
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_order_status_log/';

-- 7	ods_comment_info	商品评论表	增量
drop table if exists ods_comment_info;
create external table ods_comment_info(
  `id` STRING COMMENT '编号',
  `user_id` STRING COMMENT '用户名称',
  `sku_id` STRING COMMENT 'skuid',
  `spu_id` STRING COMMENT '商品id',
  `order_id` STRING COMMENT '订单编号',
  `appraise` STRING COMMENT '评价 1 好评 2 中评 3 差评',
  `comment_txt` varchar(2000) COMMENT '评价内容',
  `create_time` STRING COMMENT '创建时间',
  `operate_time` STRING COMMENT '修改时间'
) COMMENT '商品评论表'
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_comment_info/';

-- 8	ods_order_refund_info	退单表	增量
drop table if exists ods_order_refund_info;
create external table ods_order_refund_info(
  `id` string COMMENT '编号',
  `user_id` string COMMENT '用户id',
  `order_id` string COMMENT '订单编号',
  `sku_id` string COMMENT 'skuid',
  `refund_type` string COMMENT '退款类型',
  `refund_num` string COMMENT '退货件数',
  `refund_amount` decimal(16,2) COMMENT '退款金额',
  `refund_reason_type` string COMMENT '原因类型',
  `refund_reason_txt` string COMMENT '原因内容',
  `create_time` string COMMENT '创建时间'
) COMMENT '退单表'
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_order_refund_info/';

-- 9	ods_activity_order	活动订单关联表	增量
drop table if exists ods_activity_order;
create external table ods_activity_order(
  `id` string COMMENT '编号',
  `activity_id` string COMMENT '活动id ',
  `order_id` string COMMENT '订单编号',
  `create_time` string COMMENT '发生日期'
) COMMENT '活动订单关联表'
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_activity_order/';

-- 10	ods_sku_info	SKU商品表	全量
drop table if exists ods_sku_info;
create external table ods_sku_info(
  `id` string COMMENT 'skuid(itemID)',
  `spu_id` string COMMENT 'spuid',
  `price` decimal(10,0)  COMMENT '价格',
  `sku_name` string COMMENT 'sku名称',
  `sku_desc` string COMMENT '商品规格描述',
  `weight` decimal(10,2) COMMENT '重量',
  `tm_id` string COMMENT '品牌(冗余)',
  `category3_id` string COMMENT '三级分类id（冗余)',
  `sku_default_img` string COMMENT '默认显示图片(冗余)',
  `create_time` string COMMENT '创建时间'
) COMMENT 'SKU商品表'
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_sku_info/';

-- 11	ods_base_category1	商品一级分类表	全量
drop table if exists ods_base_category1;
create external table ods_base_category1(
    `id` string COMMENT 'id',
    `name`  string COMMENT '名称'
) COMMENT '商品一级分类表'
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_base_category1/';

-- 12	ods_base_category2	商品二级分类表	全量
drop table if exists ods_base_category2;
create external table ods_base_category2(
    `id` string COMMENT ' id',
    `name` string COMMENT '名称',
    `category1_id` string COMMENT '一级品类id'
) COMMENT '商品二级分类表'
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_base_category2/';

-- 13	ods_base_category3	商品三级分类表	全量
drop table if exists ods_base_category3;
create external table ods_base_category3(
    `id` string COMMENT ' id',
    `name`  string COMMENT '名称',
    `category2_id` string COMMENT '二级品类id'
) COMMENT '商品三级分类表'
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_base_category3/';

-- 14	ods_base_trademark	品牌表	全量
drop table if exists ods_base_trademark;
create external table ods_base_trademark(
    `tm_id`   bigint COMMENT '编号',
    `tm_name` string COMMENT '品牌名称'
)  COMMENT '品牌表'
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_base_trademark/';

-- 15	ods_spu_info	SPU商品表	全量
drop table if exists ods_spu_info;
create external table ods_spu_info(
  `id` string COMMENT '商品id',
  `spu_name` string COMMENT '商品名称',
  `description` string COMMENT '商品描述(后台简述）',
  `category3_id` string COMMENT '三级分类id',
  `tm_id` string COMMENT '品牌id'
) COMMENT 'SPU商品表'
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_spu_info/';

-- 16	ods_cart_info	加购表	全量
drop table if exists ods_cart_info;
create external table ods_cart_info(
  `id` string COMMENT '编号',
  `user_id` string COMMENT '用户id',
  `sku_id` string COMMENT 'skuid',
  `cart_price` decimal(10,2) COMMENT '放入购物车时价格',
  `sku_num` string COMMENT '数量',
  `img_url` string COMMENT '图片文件',
  `sku_name` string COMMENT 'sku名称 (冗余)',
  `create_time` string COMMENT '创建时间',
  `operate_time` string COMMENT '修改时间',
  `is_ordered` string COMMENT '是否已经下单',
  `order_time` string COMMENT '下单时间',
  `source_type` string COMMENT '来源类型',
  `source_id` string COMMENT '来源编号'
) COMMENT '加购表'
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_cart_info/';

-- 17	ods_favor_info	商品收藏表	全量
drop table if exists ods_favor_info;
create external table ods_favor_info(
  `id` string COMMENT '编号',
  `user_id` string COMMENT '用户名称',
  `sku_id` string COMMENT 'skuid',
  `spu_id` string COMMENT '商品id',
  `is_cancel` string COMMENT '是否已取消 0 正常 1 已取消',
  `create_time` string COMMENT '创建时间',
  `cancel_time` string COMMENT '修改时间'
) COMMENT '商品收藏表'
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_favor_info/';

-- 18	ods_coupon_info	优惠券表	全量
drop table if exists ods_coupon_info;
create external table ods_coupon_info(
  `id` string COMMENT '购物券编号',
  `coupon_name` string COMMENT '购物券名称',
  `coupon_type` string COMMENT '购物券类型 1 现金券 2 折扣券 3 满减券 4 满件打折券',
  `condition_amount` decimal(10,2) COMMENT '满额数',
  `condition_num` string COMMENT '满件数',
  `activity_id` string COMMENT '活动编号',
  `benefit_amount` decimal(16,2) COMMENT '减金额',
  `benefit_discount` string COMMENT '折扣',
  `create_time` string COMMENT '创建时间',
  `range_type` string COMMENT '范围类型 1、商品 2、品类 3、品牌',
  `spu_id` string COMMENT '商品id',
  `tm_id` string COMMENT '品牌id',
  `category3_id` string COMMENT '品类id',
  `limit_num` string COMMENT '最多领用次数',
  `operate_time` string COMMENT '修改时间',
  `expire_time` string COMMENT '过期时间'
) COMMENT '优惠券表'
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_coupon_info/';

-- 19	ods_activity_info	活动表	全量
drop table if exists ods_activity_info;
create external table ods_activity_info(
  `id` string COMMENT '活动id',
  `activity_name` string COMMENT '活动名称',
  `activity_type` string COMMENT '活动类型',
  `activity_desc` string COMMENT '活动描述',
  `start_time` string COMMENT '开始时间',
  `end_time` string COMMENT '结束时间',
  `create_time` string COMMENT '创建时间'
) COMMENT '活动表'
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_activity_info/';

-- 20	ods_activity_rule	优惠规则表	全量
drop table if exists ods_activity_rule;
create external table ods_activity_rule(
  `id` string COMMENT '编号',
  `activity_id` string COMMENT '类型',
  `condition_amount` decimal(16,2) COMMENT '满减金额',
  `condition_num` string COMMENT '满减件数',
  `benefit_amount` decimal(16,2) COMMENT '优惠金额',
  `benefit_discount` string COMMENT '优惠折扣',
  `benefit_level` string COMMENT '优惠级别'
) COMMENT '优惠规则表'
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_activity_rule/';

-- 21	ods_activity_sku	参与活动商品表	全量
drop table if exists ods_activity_sku;
create external table ods_activity_sku(
  `id` string COMMENT '编号',
  `activity_id` string COMMENT '活动id ',
  `sku_id` string COMMENT 'sku_id',
  `create_time` string COMMENT '创建时间'
) COMMENT '参与活动商品表'
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_activity_sku/';

-- 22	ods_base_dic	编码字典表	全量
drop table if exists ods_base_dic;
create external table ods_base_dic(
  `dic_code` string COMMENT '编号',
  `dic_name` string COMMENT '编码名称',
  `parent_code` string COMMENT '父编号',
  `create_time` string COMMENT '创建日期',
  `operate_time` string COMMENT '修改日期'
) COMMENT '编码字典表'
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_base_dic/';

-- 23	ods_base_province	省份表	特殊
drop table if exists ods_base_province;
create external table ods_base_province(
  `id` string COMMENT 'id',
  `name` string COMMENT '省名称',
  `region_id` string COMMENT '大区id',
  `area_code` string COMMENT '行政区位码',
  `iso_code` string COMMENT '国际编码'
) COMMENT '省份表'
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_base_province/';

-- 24	ods_base_region	地区表	特殊
drop table if exists ods_base_region;
create external table ods_base_region(
  `id` string COMMENT '大区id',
  `region_name` string COMMENT '大区名称'
) COMMENT '地区表'
partitioned by  (`dt` string)
row format delimited fields terminated by '\t'
STORED AS textfile
location '/warehouse/gmall/ods/ods_base_region/';