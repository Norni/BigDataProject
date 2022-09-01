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

`/datawarehouse_project/script/cluster_zookeeper_control.sh`



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

- 默认配置文件：`/datawarehouse_project/conf/hadoop/defalut`
- 用户配置文件：`/datawarehouse_project/conf/hadoop/user`

**服务启停脚本:**

`/datawarehouse_project/script/cluster_hadoop_control.sh`



## 3.3 hive

**笔记：**

[一、Hive简明笔记 - Norni - 博客园 (cnblogs.com)](https://www.cnblogs.com/nuochengze/p/15374643.html)

**下载路径：**

[Index of /dist/hive (apache.org)](http://archive.apache.org/dist/hive/)

**服务启停脚本:**

`/datawarehouse_project/script/cluster_hive_control.sh`



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

`/datawarehouse_project/script/cluster_kafka_control.sh`



# 4、模拟数据生成模块



## 4.1 模拟行为数据生成



### 4.1.1 普通页面埋点日志数据

说明：

要模拟的数据主要包括：页面数据（page）、事件数据（actions）、曝光数据（display）、公共数据（common）和错误数据（error）

- 页面数据（page data）主要记录一个页面的用户访问情况，包括访问时间、停留时间、页面路径等信息
- 事件数据（action data）主要记录应用内一个具体操作行为，包括操作类型、操作对象、操作对象描述等信息。
- 曝光数据（display data）主要记录页面所曝光的内容，包括曝光对象，曝光类型等信息。
- 公共数据（common data）主要是记录用户设备，用户会员等信息。

**示例josn：**

`datawarehouse_project/data/simulation_data/log_data/buried_log_data_json_example/page_buried_log_data.json`



### 4.1.2 启动日志数据

**示例josn：**

`datawarehouse_project/data/simulation_data/log_data/buried_log_data_json_example/start_buried_log_data.json`



## 4.2 模拟业务数据生成



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

``

| 序号 | 表中文名       | 表英文名          |
| ---- | -------------- | ----------------- |
| 1    | 订单表         | order_info        |
| 2    | 订单详情表     | order_detail      |
| 3    | SKU商品表      | sku_info          |
| 4    | 用户表         | user_info         |
| 5    | 商品1级分类表  | base_category1    |
| 6    | 商品2级分类表  | base_category2    |
| 7    | 商品3级分类表  | base_category3    |
| 8    | 支付流水表     | payment_info      |
| 9    | 省份表         | base_province     |
| 10   | 地区表         | base_region       |
| 11   | 品牌表         | base_trademark    |
| 12   | 订单状态表     | order_status_log  |
| 13   | SPU商品表      | spu_info          |
| 14   | 商品评论表     | comment_info      |
| 15   | 退单表         | order_refund_info |
| 16   | 加购表         | cart_info         |
| 17   | 商品收藏表     | favor_info        |
| 18   | 优惠卷领用表   | coupon_use        |
| 19   | 优惠卷表       | coupon_info       |
| 20   | 活动表         | activity_info     |
| 21   | 活动订单关联表 | activity_order    |
| 22   | 优惠规则表     | activity_rule     |
| 23   | 编码字典表     | base_dic          |
| 24   | 参与活动商品表 | activity_sku      |



# 5、数据采集模块

## 5.1 用户行为数据采集

## 5.2 业务数据采集

<img src="https://img2022.cnblogs.com/blog/1837946/202208/1837946-20220810113849817-151813874.png" style="zoom:60%;" align="left"/>

