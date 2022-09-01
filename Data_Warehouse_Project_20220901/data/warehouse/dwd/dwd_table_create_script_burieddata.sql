use gmall;

-- dwd_start_log
drop table if exists dwd_start_log;
create external table if not exists dwd_start_log(
    `area_code` string COMMENT '地区编码',
    `brand` string COMMENT '手机品牌',
    `channel` string COMMENT '渠道',
    `model` string COMMENT '手机型号',
    `mid_id` string COMMENT '设备id',
    `os` string COMMENT '操作系统',
    `user_id` string COMMENT '会员id',
    `version_code` string COMMENT 'app版本号',
    `entry` string COMMENT ' icon手机图标  notice 通知   install 安装后启动',
    `loading_time` bigint COMMENT '启动加载时间',
    `open_ad_id` string COMMENT '广告页ID ',
    `open_ad_ms` string COMMENT '广告总共播放时间',
    `open_ad_skip_ms` string COMMENT '用户跳过广告时点',
    `error_code` string COMMENT '错误码',
    `error_msg` string comment '错误信息',
    `ts` string COMMENT '时间'
) COMMENT '启动日志表'
partitioned by (`dt` string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_start_log';

-- dwd_page_log
drop table if exists dwd_page_log;
create external table if not exists dwd_page_log
(
    `area_code`      string COMMENT '地区编码',
    `brand`          string COMMENT '手机品牌',
    `channel`        string COMMENT '渠道',
    `model`          string COMMENT '手机型号',
    `mid_id`         string COMMENT '设备id',
    `os`             string COMMENT '操作系统',
    `user_id`        string COMMENT '会员id',
    `version_code`   string COMMENT 'app版本号',
    `during_time`    bigint COMMENT '持续时间毫秒',
    `page_item`      string COMMENT '目标id ',
    `page_item_type` string COMMENT '目标类型',
    `last_page_id`   string COMMENT '上页类型',
    `page_id`        string COMMENT '页面ID ',
    `source_type`    string COMMENT '来源类型',
    `error_code`     string COMMENT '错误码',
    `error_msg`      string comment '错误信息',
    `ts`             string COMMENT '时间'
) COMMENT '页面日志表'
PARTITIONED BY (dt string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_page_log';

-- dwd_action_log
drop table if exists dwd_action_log;
CREATE EXTERNAL TABLE dwd_action_log(
    `area_code` string COMMENT '地区编码',
    `brand` string COMMENT '手机品牌',
    `channel` string COMMENT '渠道',
    `model` string COMMENT '手机型号',
    `mid_id` string COMMENT '设备id',
    `os` string COMMENT '操作系统',
    `user_id` string COMMENT '会员id',
    `version_code` string COMMENT 'app版本号',
    `during_time` bigint COMMENT '持续时间毫秒',
    `page_item` string COMMENT '目标id ',
    `page_item_type` string COMMENT '目标类型',
    `last_page_id` string COMMENT '上页类型',
    `page_id` string COMMENT '页面id ',
    `source_type` string COMMENT '来源类型',
    `action_id` string COMMENT '动作id',
    `item` string COMMENT '目标id ',
    `item_type` string COMMENT '目标类型',
    `action_ts` string comment '动作时间戳',
    `error_code`     string COMMENT '错误码',
    `error_msg`      string comment '错误信息',
    `ts`             string COMMENT '时间'
) COMMENT '动作日志表'
PARTITIONED BY (dt string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_action_log';


-- dwd_display_log
drop table if exists dwd_display_log;
CREATE EXTERNAL TABLE dwd_display_log(
    `area_code` string COMMENT '地区编码',
    `brand` string COMMENT '手机品牌',
    `channel` string COMMENT '渠道',
    `model` string COMMENT '手机型号',
    `mid_id` string COMMENT '设备id',
    `os` string COMMENT '操作系统',
    `user_id` string COMMENT '会员id',
    `version_code` string COMMENT 'app版本号',
    `during_time` bigint COMMENT 'app版本号',
    `page_item` string COMMENT '目标id ',
    `page_item_type` string COMMENT '目标类型',
    `last_page_id` string COMMENT '上页类型',
    `page_id` string COMMENT '页面ID ',
    `source_type` string COMMENT '来源类型',
    `display_type` string COMMENT '曝光类型',
    `item` string COMMENT '曝光对象id ',
    `item_type` string COMMENT 'app版本号',
    `seq` bigint COMMENT '出现顺序',
    `error_code`     string COMMENT '错误码',
    `error_msg`      string comment '错误信息',
    `ts`             string COMMENT '时间'
) COMMENT '曝光日志表'
PARTITIONED BY (dt string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_display_log';