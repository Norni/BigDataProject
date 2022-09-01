#! /bin/bash


if [ $# -ne 1 ]
then
    echo "Usage: $0 start|stop"
    exit;
fi


case $1 in
    "start"){
         /home/nuochengze/datawarehouse_project/script/flume_control_file_to_kafka.sh start
         /home/nuochengze/datawarehouse_project/script/flume_control_kafka_to_hdfs.sh start
    };;
    "stop"){
         /home/nuochengze/datawarehouse_project/script/flume_control_kafka_to_hdfs.sh stop
         /home/nuochengze/datawarehouse_project/script/flume_control_file_to_kafka.sh stop
    };;
    *){
	echo "Usage: $0 start|stop"
	exit;
};;
esac
