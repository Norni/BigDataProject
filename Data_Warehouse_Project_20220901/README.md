[toc]

说明：

项目来源于 【尚硅谷】，本人主要用于学习及实践，整理出个人笔记，如您感兴趣，可关注尚硅谷官网，或B站尚硅谷获取内容。



# 1、项目需求

| 编号 | 项目需求                                                     | 备注 |
| :--- | ------------------------------------------------------------ | ---- |
| 1    | 用户行为数据采集平台搭建                                     |      |
| 2    | 业务数据采集平台搭建                                         |      |
| 3    | 数据仓库维度建模                                             |      |
| 4    | 分析用户、流量、会员、商品、销售、地区、活动等电商核心主题，合计报表指标近100个 |      |
| 5    | 采用即席查询工具，随时进行指标分析                           |      |
| 6    | 对集群性能进行监控，发生异常需要报警                         |      |
| 7    | 元数据管理                                                   |      |
| 8    | 质量监控                                                     |      |

# 2、项目框架

## 2.1 技术选型

技术选型主要考虑因素：数据量大小、业务需求、行业内经验、技术成熟度、开发维护成本、总成本预算。

| 编号 | 项目         | 举例框架                           |
| ---- | ------------ | ---------------------------------- |
| 1    | 数据采集传输 | Flume、Kafka、Sqoop                |
| 2    | 数据存储     | MySql，HDFS，HBase，Redis，MongoDB |
| 3    | 数据计算     | Hive，Spark，Flink                 |
| 4    | 数据查询     | Presto，Druid，Kylin               |
| 5    | 数据可视化   | Echart、Superset、QuickBI          |
| 6    | 任务调度     | Azkaban、Oozie                     |
| 7    | 集群监控     | Zabbix                             |
| 8    | 元数据管理   | Atlas                              |
| 9    | 数据质量监控 | Shell、Python                      |

## 2.2 数据流程设计

<img src="https://img2022.cnblogs.com/blog/1837946/202206/1837946-20220614153829461-1867417615.png" style="zoom:50%;" align="left"/>

## 2.3 框架版本选型

选择Apache系列。

**软件版本选择时，尽量选择稳定版本。**

软件版本如下（部分）：

| 编号 | 产品      | 版本             |
| ---- | --------- | ---------------- |
| 1    | hadoop    | 3.2.2            |
| 2    | hbase     | 1.3.1            |
| 3    | hive      | 3.1.2            |
| 4    | flume     | 1.9.0            |
| 5    | jdk       | 1.8              |
| 6    | kafka     | kafka_2.11-2.4.1 |
| 7    | scala     | 2.12.11          |
| 8    | spark     | 3.1.2            |
| 9    | sqoop     | 1.4.6            |
| 10   | zookeeper | 3.5.7            |
| 11   | mysql     | 8.0.29-Community |

## 2.4 服务器选型

实际可按容量+用途进行选择。

这里选择虚拟机。



## 2.5 集群资源规划设计

<img src="https://img2022.cnblogs.com/blog/1837946/202206/1837946-20220614163612318-1560084575.jpg" style="zoom:50%;" align="left"/>

说明：

服务器pc001的应该赋予更多的资源以满足运行需求。



# 3、软件部署

**软件层级:**

<img src="https://img2022.cnblogs.com/blog/1837946/202208/1837946-20220808165612400-958956714.png" style="zoom:65%;" align="left"/>



## 3.1 zookeeper

**笔记：**

[一、Zookeeper简明笔记 - Norni - 博客园 (cnblogs.com)](https://www.cnblogs.com/nuochengze/p/15337620.html)

**集群规划:**

| 项目/Vserion      | 服务器node001 | 服务器node002 | 服务器node003 |
| ----------------- | ------------- | ------------- | ------------- |
| Zookeeper / 3.5.7 | √             | √             | √             |

**下载路径：**

[Index of /dist/zookeeper (apache.org)](https://archive.apache.org/dist/zookeeper/)

**服务启停脚本:**

`/Data_Warehouse_Project_20220901/script/cluster_zookeeper_control.sh`



## 3.2 hadoop

**笔记:**

[七、Hadoop简明笔记 - Norni - 博客园 (cnblogs.com)](https://www.cnblogs.com/nuochengze/p/15334016.html)

**下载路径:**

[Index of /dist/hadoop/common (apache.org)](https://archive.apache.org/dist/hadoop/common/)

**集群规划:**

| 项目/hadoop-3.2.2 | node001           | node002                    | node003                    |
| ----------------- | ----------------- | -------------------------- | -------------------------- |
| HDFS              | NameNode DataNode | DataNode                   | SecondaryNameNode DataNode |
| YARN              | NodeManager       | ResoureManager NodeManager | NodeManager                |

**配置信息:**

- 默认配置文件：`/Data_Warehouse_Project_20220901/conf/hadoop/defalut`
- 用户配置文件：`/Data_Warehouse_Project_20220901/conf/hadoop/user`

**服务启停脚本:**

`/Data_Warehouse_Project_20220901/script/cluster_hadoop_control.sh`

**优化报告：**

`更新中`

**压测报告：**

`更新中`



## 3.3 hive

**笔记：**

[一、Hive简明笔记 - Norni - 博客园 (cnblogs.com)](https://www.cnblogs.com/nuochengze/p/15374643.html)

**下载路径：**

[Index of /dist/hive (apache.org)](http://archive.apache.org/dist/hive/)

**服务启停脚本:**

`/Data_Warehouse_Project_20220901/script/cluster_hive_control.sh`



## 3.4 sqoop

**笔记：**

[一、Sqoop简明笔记 - Norni - 博客园 (cnblogs.com)](https://www.cnblogs.com/nuochengze/p/15400084.html)

**下载路径：**

[Index of /dist/sqoop (apache.org)](https://archive.apache.org/dist/sqoop/)



## 3.5 flume

**笔记：**

[一、Flume简明笔记 - Norni - 博客园 (cnblogs.com)](https://www.cnblogs.com/nuochengze/p/15435116.html)

**下载路径：**

[Index of /dist/flume (apache.org)](https://archive.apache.org/dist/flume/)

**集群规划:**

| 项目/version-1.9.0 | 服务器node001 | 服务器node002 | 服务器node003 |
| ------------------ | ------------- | ------------- | ------------- |
| Flume(采集日志)    | Flume         | Flume         |               |

**安装步骤：**

1. 解压到目录

2. 重命名

3. 将lib文件夹下的guava-11.0.2.jar删除以兼容Hadoop

4. 将flume/conf下的flume-env.sh.template文件修改为flume-env.sh，并配置flume-env.sh文件

   ```shell
   export JAVA_HOME=/opt/software/jdk8u302b08
   ```

**优化报告：**

`更新中`

**参考文档: **

> [Flume用户手册中文翻译版 - 《Flume 1.8用户手册中文版》 - 书栈网 · BookStack](https://www.bookstack.cn/read/flumeUserGuideCnDoc-1.8/README.md)
>
> [Flume 1.10.0 User Guide — Apache Flume](https://flume.apache.org/releases/content/1.10.0/FlumeUserGuide.html)



## 3.6 kafka

**笔记：**

[一、kafka简明笔记 - Norni - 博客园 (cnblogs.com)](https://www.cnblogs.com/nuochengze/p/15395848.html)

**下载路径：**

[Index of /dist/kafka (apache.org)](https://archive.apache.org/dist/kafka/)

**集群规划:**

|      | hadoop102 | hadoop103 | hadoop104 |
| ---- | --------- | --------- | --------- |
|      | zk        | zk        | zk        |
|      | kafka     | kafka     | kafka     |

**服务启停脚本:**

`/Data_Warehouse_Project_20220901/script/cluster_kafka_control.sh`

**优化报告：**

`更新中`

**压测报告：**

`更新中`



## 3.7 azkaban



# 4、模拟数据生成模块



## 4.1 模拟行为数据生成

数据生成脚本：`/Data_Warehouse_Project_20220901/script/generate_buried_log_data.sh`



### 4.1.1 普通页面埋点日志数据

说明：

要模拟的数据主要包括：页面数据（page）、事件数据（actions）、曝光数据（display）、公共数据（common）和错误数据（error）

- 页面数据（page data）主要记录一个页面的用户访问情况，包括访问时间、停留时间、页面路径等信息
- 事件数据（action data）主要记录应用内一个具体操作行为，包括操作类型、操作对象、操作对象描述等信息。
- 曝光数据（display data）主要记录页面所曝光的内容，包括曝光对象，曝光类型等信息。
- 公共数据（common data）主要是记录用户设备，用户会员等信息。

**示例josn：**

`Data_Warehouse_Project_20220901/data/simulation_data/log_data/buried_log_data_json_example/page_buried_log_data.json`



### 4.1.2 启动日志数据

**示例josn：**

`Data_Warehouse_Project_20220901/data/simulation_data/log_data/buried_log_data_json_example/start_buried_log_data.json`



## 4.2 模拟业务数据生成

数据生成脚本：`/home/nuochengze/Data_Warehouse_Project_20220901/script/generate_business_data.sh`



### 4.2.1 业务流程图

<img src="https://img2022.cnblogs.com/blog/1837946/202208/1837946-20220809234419353-772865505.png" style="zoom:80%;" align="left" />



### 4.2.2 电商业务结构表

本电商数仓系统涉及到的业务数据表结构关系。这24个表以订单表、用户表、SKU商品表、活动表和优惠券表为中心，延伸出了优惠券领用表、支付流水表、活动订单表、订单详情表、订单状态表、商品评论表、编码字典表退单表、SPU商品表等，用户表提供用户的详细信息，支付流水表提供该订单的支付详情，订单详情表提供订单的商品数量等情况，商品表给订单详情表提供商品的详细信息。



**建模工具：**

> EZDML是一款国产免费的轻量级数据建模工具。
>
> http://www.ezdml.com/



**24张业务结构表：**

<img src="https://img2022.cnblogs.com/blog/1837946/202208/1837946-20220810123030072-2081748093.png" style="zoom:67%;" align="left"/>

**模型设计：**

`/Data_Warehouse_Project_20220901/data/simulation_data/business_data/business_data_model_design/business_model_design.xlsx`

| 序号 | 表中文名       | 表英文名          | 状态 |
| ---- | -------------- | ----------------- | ---- |
| 1    | 订单表         | order_info        | 1    |
| 2    | 订单详情表     | order_detail      |      |
| 3    | SKU商品表      | sku_info          |      |
| 4    | 用户表         | user_info         |      |
| 5    | 商品1级分类表  | base_category1    |      |
| 6    | 商品2级分类表  | base_category2    |      |
| 7    | 商品3级分类表  | base_category3    |      |
| 8    | 支付流水表     | payment_info      |      |
| 9    | 省份表         | base_province     |      |
| 10   | 地区表         | base_region       |      |
| 11   | 品牌表         | base_trademark    |      |
| 12   | 订单状态表     | order_status_log  |      |
| 13   | SPU商品表      | spu_info          |      |
| 14   | 商品评论表     | comment_info      |      |
| 15   | 退单表         | order_refund_info |      |
| 16   | 加购表         | cart_info         |      |
| 17   | 商品收藏表     | favor_info        |      |
| 18   | 优惠卷领用表   | coupon_use        |      |
| 19   | 优惠卷表       | coupon_info       |      |
| 20   | 活动表         | activity_info     |      |
| 21   | 活动订单关联表 | activity_order    |      |
| 22   | 优惠规则表     | activity_rule     |      |
| 23   | 编码字典表     | base_dic          |      |
| 24   | 参与活动商品表 | activity_sku      |      |



# 5、数据采集模块

## 5.1 用户行为数据采集

<img src="https://img2022.cnblogs.com/blog/1837946/202208/1837946-20220810163952051-1729478801.png" style="zoom:60%;" align="left"/>

**启动脚本：**

`/Data_Warehouse_Project_20220901/script/log_collect_platform_control.sh`

### 5.1.1 logFile>flume>kafka

**数据逻辑流图：**

<img src="https://img2022.cnblogs.com/blog/1837946/202208/1837946-20220810233756613-453054249.png" style="zoom:40%;" align="left"/>

**配置文件：**

`/Data_Warehouse_Project_20220901/conf/flume/file_flume_kafka.conf`

**控制脚本:**

`/Data_Warehouse_Project_20220901/script/flume_control_file_to_kafka.sh`

### 5.1.2 Kfka>flume>hdfs

**数据逻辑流图：**

<img src="https://img2022.cnblogs.com/blog/1837946/202208/1837946-20220810234401688-2023137102.png" style="zoom:40%;" align="left"/>

**配置文件：**

`/Data_Warehouse_Project_20220901/conf/flume/kafka_flume_hdfs.conf`

**控制脚本:**

`/Data_Warehouse_Project_20220901/script/flume_control_kafka_to_hdfs.sh`

## 5.2 业务数据采集

**同步策略：**

<img src="https://img2022.cnblogs.com/blog/1837946/202208/1837946-20220810113849817-151813874.png" style="zoom:60%;" align="left"/>

**控制脚本：**

`/Data_Warehouse_Project_20220901/script/sqoop_control_mysql_to_hdfs.sh`



# 6、数据仓库搭建

## 6.1 数仓分层

**数仓分层设计图：**

<img src="https://img2022.cnblogs.com/blog/1837946/202208/1837946-20220814120804125-1013458933.png" style="zoom:30%;" align="left"/>

## 6.2 数仓规范

**表命名：**

1. ODS层命名为`ods_tablename`
2. DWD层命名为`dwd_dim_tablename/dwd_fact_tablename`
3. DWS层命名为`dws_tablename`
4. DWT层命名为`dwt_tablename`
5. ADS层命名为`ads_tablename`
6. 临时表命名为`tmp_tablename`
7. 用户行为表为`log_tablename`

**脚本命名：**

1. toolname_datasourcesname_to_targetname_db/log.sh，尽量见名之意

2. 用户行为脚本以log为后缀

   业务 数据脚本以db为后缀

**三范式：**

- 1NF:属性不可切割，强调的是列的原子性，即列不能够再分成其他几列

- 2NF:不存在部分函数依赖，一是表必须有一个主键；二是没有包含在主键中的列必须完全依赖于主键，而不能只依赖于主键的一部分
- 3NF:非主键列必须直接依赖于主键，不能存在传递依赖。即不能存在：非主键列 A 依赖于非主键列 B，非主键列 B 依赖于主键的情况

**OLTP与OLAP对比：**

| **对比属性** | **OLTP**                   | **OLAP**                   |
| ------------ | -------------------------- | -------------------------- |
| **读特性**   | 每次查询只返回少量记录     | 对大量记录进行汇总         |
| **写特性**   | 随机、低延时写入用户的输入 | 批量导入                   |
| **使用场景** | 用户，Java EE项目          | 内部分析师，为决策提供支持 |
| **数据表征** | 最新数据状态               | 随时间变化的历史状态       |
| **数据规模** | GB                         | TB到PB                     |

**层级规划说明：**

1. ODS

   - 保持数据原貌不做任何修改，起到备份数据的作用
   - 数据采用压缩，减少磁盘存储空间
   - 创建分区表，防止后续的全表扫描

2. DWD

   DWD层需构建维度模型，一般采用星型模型，呈现的状态一般为星座模型。

   维度建模的一般步骤：

   1. 选择业务过程

      即业务系统的业务线。

   2. 声明粒度

      数据粒度指数据仓库的数据中保存数据的细化程度或综合程度的级别，声明粒度意味着精确定义事实表中的一行数据表示什么，应该尽可能选择**最小粒度**，以此来应各种各样的需求。

   3. 确认维度

      维度的主要作用是描述业务事实，即属于事实表的维度退化。

   4. 确认事实

      指业务中的度量值。

3. DWS

   统计各个主题对象的当天行为，服务于DWT层的主题宽表。

4. DWT

   统计各个主题对象的累积行为。

5. ADS

   对系统各大主题指标分别进行分析。

## 6.2 数仓搭建

### 6.2.1 ODS层

#### 6.2.1.1 用户行为数据

**创表语句：**

```sql
drop table if exists ods_start_log;
create external table if not exists ods_start_log(
    line string
)
partitioned by (dt string)
stored as textfile
location '/warehouse/gmall/ods/ods_start_log';


drop table if exists ods_event_log;
create external table if not exists ods_event_log(
    line string
)
partitioned by (dt string)
stored as textfile
location '/warehouse/gmall/ods/ods_event_log';
```

**ods层数据加载脚本：**

`/home/nuochengze/Data_Warehouse_Project_20220901/script/sqoop_control_burieddata_hdfs_to_ods_log.sh`

**脚本执行时间：**

每日凌晨30分~1点。

#### 6.2.1.2 业务数据

**业务表清单及同步策略：**

| 序号 | 表名                  | 表中文名       | 更新策略   | 备注 |
| ---- | --------------------- | -------------- | ---------- | ---- |
| 1    | ods_order_info        | 订单表         | 增量及更新 |      |
| 2    | ods_user_info         | 用户表         | 增量及更新 |      |
| 3    | ods_coupon_use        | 优惠券领用表   | 新增及变化 |      |
| 4    | ods_order_detail      | 订单详情表     | 增量       |      |
| 5    | ods_payment_info      | 支付流水表     | 增量       |      |
| 6    | ods_order_status_log  | 订单状态表     | 增量       |      |
| 7    | ods_comment_info      | 商品评论表     | 增量       |      |
| 8    | ods_order_refund_info | 退单表         | 增量       |      |
| 9    | ods_activity_order    | 活动订单关联表 | 增量       |      |
| 10   | ods_sku_info          | SKU商品表      | 全量       |      |
| 11   | ods_base_category1    | 商品一级分类表 | 全量       |      |
| 12   | ods_base_category2    | 商品二级分类表 | 全量       |      |
| 13   | ods_base_category3    | 商品三级分类表 | 全量       |      |
| 14   | ods_base_trademark    | 品牌表         | 全量       |      |
| 15   | ods_spu_info          | SPU商品表      | 全量       |      |
| 16   | ods_cart_info         | 加购表         | 全量       |      |
| 17   | ods_favor_info        | 商品收藏表     | 全量       |      |
| 18   | ods_coupon_info       | 优惠券表       | 全量       |      |
| 19   | ods_activity_info     | 活动表         | 全量       |      |
| 20   | ods_activity_rule     | 优惠规则表     | 全量       |      |
| 21   | ods_activity_sku      | 参与活动商品表 | 全量       |      |
| 22   | ods_base_dic          | 编码字典表     | 全量       |      |
| 23   | ods_base_province     | 省份表         | 特殊       |      |
| 24   | ods_base_region       | 地区表         | 特殊       |      |

**创表语句：**

`/Data_Warehouse_Project_20220901/data/warehouse/ods/ods_table_create_script.sql`

**ods层加载数据脚本：**

`/Data_Warehouse_Project_20220901/script/sqoop_control_businessdata_hdfs_to_hivedb_ods.sh`



### 6.2.2 DWD层

#### 6.2.2.1 用户行为日志解析

| 表名       |
| ---------- |
| 启动日志表 |
| 页面日志表 |
| 动作日志表 |
| 曝光日志表 |

**创表语句：**

`/Data_Warehouse_Project_20220901/data/warehouse/dwd/dwd_table_create_script_burieddata.sql`

**dwd层数据加载脚本：**

`/Data_Warehouse_Project_20220901/script/hive_control_burieddata_hivedb_ods_to_dwd.sh`

**UDF函数：**

`/Data_Warehouse_Project_20220901/codes/hive/customer_udf`

```sql
create function ParseLogLine_UDF
    as 'com.nuochengze.udf.ParseLogLine_UDF' using jar 'hdfs://node001:9820/hive/jars/customer_udf-1.0-SNAPSHOT.jar';
create function get_json_array
    as 'com.nuochengze.udtf.ExplodeJSONArray' using jar 'hdfs://node001:9820/hive/jars/customer_udf-1.0-SNAPSHOT.jar';
```

####  6.2.2.2 业务数据解析

**导入策略：**

| 全量         | 特殊       | 事务型事实表   | 周期型快照事实表 | 累积型快照事实表 | 拉链表     |
| ------------ | ---------- | -------------- | ---------------- | ---------------- | ---------- |
| 商品维度表   | 地区维度表 | 支付事实表     | 加购事实表       | 优惠卷领用事实表 | 用户维度表 |
| 优惠卷维度表 | 时间维度表 | 退款事实表     | 收藏事实表       | 订单事实表       |            |
| 活动维度表   |            | 评价事实表     |                  |                  |            |
|              |            | 订单明细事实表 |                  |                  |            |

周期型快照事实表数量是会发生变化，区别于区别于事务型事实表是每天导入新增，但周期型快照事实表存储的数据比较讲究时效性，所以可以适时删除以前的数据。

订单生命周期：创建时间=》支付时间=》取消时间=》完成时间=》退款时间=》退款完成时间。

用户表中的数据每日既有可能新增，也有可能修改，但修改频率并不高，属于缓慢变化维度，此处采用拉链表存储用户维度数据。

拉链表：记录每条信息的生命周期，一旦一条记录的生命周期结束，就重新开始一条新的记录，并把当前日期放入生效开始日期。



**拉链表制作步骤：**

<img src="https://img2022.cnblogs.com/blog/1837946/202208/1837946-20220824100136378-1090166611.png" style="zoom: 40%;" align="left"/>

1. 初始化

   ```sql
   -- 创建表
   drop table if exists dwd_dim_user_info_his;
   create external table dwd_dim_user_info_his(
       `id` string COMMENT '用户id',
       `name` string COMMENT '姓名',
       `birthday` string COMMENT '生日',
       `gender` string COMMENT '性别',
       `email` string COMMENT '邮箱',
       `user_level` string COMMENT '用户等级',
       `create_time` string COMMENT '创建时间',
       `operate_time` string COMMENT '操作时间',
       `start_date`  string COMMENT '有效开始日期',
       `end_date`  string COMMENT '有效结束日期'
   ) COMMENT '用户拉链表'
   stored as textfile
   location '/warehouse/gmall/dwd/dwd_dim_user_info_his/';
   
   -- 初始化数据
   insert overwrite table dwd_dim_user_info_his
   select
       id,
       name,
       birthday,
       gender,
       email,
       user_level,
       create_time,
       operate_time,
       '2022-08-18',
       '9999-99-99'
   from ods_user_info oi
   where oi.dt='2022-08-18';
   ```

2. 制作当日变动数据（包括新增，修改）每日执行

   ```sql
   -- 建立临时表
   drop table if exists dwd_dim_user_info_his_tmp;
   create external table dwd_dim_user_info_his_tmp(
       `id` string COMMENT '用户id',
       `name` string COMMENT '姓名',
       `birthday` string COMMENT '生日',
       `gender` string COMMENT '性别',
       `email` string COMMENT '邮箱',
       `user_level` string COMMENT '用户等级',
       `create_time` string COMMENT '创建时间',
       `operate_time` string COMMENT '操作时间',
       `start_date`  string COMMENT '有效开始日期',
       `end_date`  string COMMENT '有效结束日期'
   ) COMMENT '订单拉链临时表'
   stored as textfile
   location '/warehouse/gmall/dwd/dwd_dim_user_info_his_tmp/';
   
   -- 
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
                   '2022-08-18' start_date,
                   '9999-99-99' end_date
            from ods_user_info
            where dt = '2022-08-18'
   
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
                     where dt = '2022-08-18'
                 ) ui on uh.id = ui.id
        ) his
   order by his.id, start_date;
   ```

3. 把临时表覆盖给拉链表

   ```sql
   insert overwrite table dwd_dim_user_info_his 
   select * from dwd_dim_user_info_his_tmp;
   ```

**创表语句：**

`/Data_Warehouse_Project_20220901/data/warehouse/dwd/dwd_table_create_script_businessdata.sql`

**导数语句：**

`/Data_Warehouse_Project_20220901/script/hive_control_businessdata_hivedb_ods_to_dwd.sh`



### 6.2.3 DWS层

| 表名           |
| -------------- |
| 每日设备行为表 |
| 每日会员行为表 |
| 每日商品行为表 |
| 每日活动统计表 |
| 每日地区统计表 |

**创表语句：**

`/Data_Warehouse_Project_20220901/data/warehouse/dws/dws_table_create_script.sql`

**导数语句：**

`/home/nuochengze/Data_Warehouse_Project_20220901/script/hive_control_hivedb_dwd_to_dws.sh`



### 6.2.4 DWT层

| 表名         | ADS层衍生                                                    |
| ------------ | ------------------------------------------------------------ |
| 设备主题宽表 | 活跃设备数（日、周、月）                                     |
|              | 每日新增设备                                                 |
|              | 留存率                                                       |
|              | 沉默用户数                                                   |
|              | 本周回流用户数                                               |
|              | 流失用户数                                                   |
|              | 最近连续三周活跃用户数                                       |
|              | 最近七天内连续三天活跃用户数                                 |
| 会员主题宽表 | 会员信息（活跃会员数、新增会员数、新增消费会员数、总付费会员数、总会员数、会员活跃率、会员付费率） |
|              | 漏斗分析（统计“浏览首页->浏览商品详情页->加入购物车->下单->支付”的转化率） |
| 商品主题宽表 | 商品个数信息                                                 |
|              | 商品销量排名                                                 |
|              | 商品收藏排名                                                 |
|              | 商品加入购物车排名                                           |
|              | 商品退款率排名（最近30天）                                   |
|              | 商品差评率                                                   |
| 活动主题宽表 | 下单数目统计（单日下单笔数、单日下单金额、单日下单用户数）   |
|              | 支付信息统计（每日支付金额、支付人数、支付商品数、支付笔数以及下单到支付的平均时长） |
|              | 品牌复购率                                                   |
| 地区主题宽表 | 地区名称、当天活跃设备数、当天下单次数、当天下单金额、当天支付次数、当天支付金额 |

**创表语句：**

`/Data_Warehouse_Project_20220901/data/warehouse/dwt/dwt_table_create_script.sql`

**导数语句：**

`/Data_Warehouse_Project_20220901/script/hive_control_hivedb_dws_to_dwt.sh`

### 6.2.5 ADS层

略



# 7、任务调度

## 7.1 Azkaban调度

参考：

> [一、Azkaban简明笔记 - Norni - 博客园 (cnblogs.com)](https://www.cnblogs.com/nuochengze/p/16648348.html)

**脚本框架图：**

<img src="https://img2022.cnblogs.com/blog/1837946/202209/1837946-20220901105319748-1073322362.png" style="zoom: 33%;" align="left"/>

**文件存放路径：**`/Data_Warehouse_Project_20220901/data/azkaban/*`



# 8、数据可视化

## 8.1 Superset

# 9、即席查询

## 9.1 Kylin

## 9.2 Presto

## 9.3 Druid

# 10、集群监控

## 10.1 Zabbix

# 11、元数据管理

## 11.1 Atlas

