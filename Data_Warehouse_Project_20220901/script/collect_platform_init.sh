#! /bin/bash


# 删除topic
kafka-topics.sh --delete --topic topic_start --bootstrap-server node001:9092 >/dev/null 2>&1
kafka-topics.sh --delete --topic topic_event --bootstrap-server node001:9092 >/dev/null 2>&1


/home/nuochengze/datawarehouse_project/script/project_control.sh stop;


ssh node001 "cd /opt/software/kafka_2.11-2.4.1/data; rm -rf ./* ;cd /opt/software/kafka_2.11-2.4.1/logs;rm -rf ./*"
ssh node002 "cd /opt/software/kafka_2.11-2.4.1/data; rm -rf ./* ;cd /opt/software/kafka_2.11-2.4.1/logs;rm -rf ./*"
ssh node003 "cd /opt/software/kafka_2.11-2.4.1/data; rm -rf ./* ;cd /opt/software/kafka_2.11-2.4.1/logs;rm -rf ./*"

# 删除数据
cd "/home/nuochengze/datawarehouse_project/data/simulation_data/log_data/applog_data_store"
rm -rf ./*

# 删除taildir_position
cd "/home/nuochengze/datawarehouse_project/data/flume/file_position"
rm -rf ./*

# 删除file channel 的 checkpointer
cd "/home/nuochengze/datawarehouse_project/data/flume/flume_chnnel_filememory/checkpoint/filememory_channel_1"
rm -rf ./*
cd "/home/nuochengze/datawarehouse_project/data/flume/flume_chnnel_filememory/checkpoint/filememory_channel_2"
rm -rf ./*

# 删除file channel 的 data
cd "/home/nuochengze/datawarehouse_project/data/flume/flume_chnnel_filememory/data/filememory_channel_1"
rm -rf ./*
cd "/home/nuochengze/datawarehouse_project/data/flume/flume_chnnel_filememory/data/filememory_channel_2"
rm -rf ./*


# 删除其他server的数据
ssh node002 'rm -rf /home/nuochengze/datawarehouse_project'
ssh node003 'rm -rf /home/nuochengze/datawarehouse_project'


/home/nuochengze/datawarehouse_project/script/cluster_rsync.sh /home/nuochengze/datawarehouse_project


/home/nuochengze/datawarehouse_project/script/cluster_kafka_control.sh start;


echo "$HOSTNAME 数据初始化完成!"
