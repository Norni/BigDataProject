#! /bin/bash


if [ $# -lt 1 ]
    then
        echo "请正确输入参数(start-启动;stop-停止)"
        exit
fi

# 获取集群host
cluster_hosts_path=/home/$USER/datawarehouse_project/conf/shell/cluster_hosts/host.txt


case $1 in
"start"){
    for host in `cat $cluster_hosts_path`
        do
            echo ">>>--- current $host start kafka..."
            ssh $host "/opt/software/kafka_2.11-2.4.1/bin/kafka-server-start.sh -daemon /opt/software/kafka_2.11-2.4.1/config/server.properties"
        done
};;
"stop"){
    for host in `cat $cluster_hosts_path`
        do
            echo "===============>>>--- current $host stop kafka..."
            ssh $host "/opt/software/kafka_2.11-2.4.1/bin/kafka-server-stop.sh stop"
	    sleep 5s
        done
};;
*){
    echo "请正确输入参数(start-启动;stop-停止)"
    exit
};;
esac
