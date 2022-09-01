#! /bin/bash

hosts=("node001" "node002")

if [ $# -ne 1 ]
then
    echo "Usage: $0 start|stop";
    exit;
fi

case $1 in
"start"){
    for host in ${hosts[*]}
        do
            echo "--->>> 启动 $host 消费Flume <<<---"
            ssh $host "nohup /opt/software/flume-1.9.0/bin/flume-ng agent --name a1 --conf /opt/software/flume-1.9.0/conf --conf-file /home/nuochengze/datawarehouse_project/conf/flume/kafka_flume_hdfs.conf -Dflume.root.logger=DEBUG,console -Dorg.apache.flume.log.printconfig=true -Dorg.apache.flume.log.rawdata=true > /opt/software/flume-1.9.0/logs/${host}_consumer_log_`date '+%Y%m%d'`.log 2>&1 &"
        done
};;
"stop"){
    for host in ${hosts[*]}
        do
            echo "--->>> 停止 $host 消费Flume <<<---"
            ssh $host "ps -aux | grep -i kafka_flume_hdfs | grep -v grep | awk '{print \$2}' | xargs kill -9"
        done
};;
esac;