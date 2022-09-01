#! /bin/bash

if [ $# -lt 1 ]
    then
        echo "请正确输入参数(start-启动;stop-停止)"
        exit
fi


function start(){
    echo ">>>--- 集群启动 ---<<<"
    
    echo ">>>---启动zookeeper"
    /home/$USER/datawarehouse_project/script/cluster_zookeeper_control.sh start
   
    echo ">>>---启动hadoop"
    /home/$USER/datawarehouse_project/script/cluster_hadoop_control.sh start
    
    echo ">>>---启动hive"
    /home/$USER/datawarehouse_project/script/cluster_hive_control.sh start
    
    echo ">>>---启动kakfa"
    /home/$USER/datawarehouse_project/script/cluster_kafka_control.sh start
    
    echo ">>>---启动日志采集平台"
    /home/nuochengze/datawarehouse_project/script/log_collect_platform_control.sh start

    echo ">>>---启动任务调度平台"
    /home/nuochengze/datawarehouse_project/script/cluster_azkaban_control.sh start
    
    echo ">>>--- start completed!"
}

function stop(){
    echo ">>>--- 集群关闭 ---<<<"

    echo ">>>---关闭任务调度平台"
    /home/nuochengze/datawarehouse_project/script/cluster_azkaban_control.sh stop

    echo ">>>---关闭日志采集平台"
    /home/nuochengze/datawarehouse_project/script/log_collect_platform_control.sh stop
    
    echo ">>>---关闭kafka"
    /home/$USER/datawarehouse_project/script/cluster_kafka_control.sh stop

    echo ">>>---关闭hive"
    /home/$USER/datawarehouse_project/script/cluster_hive_control.sh stop
    
    echo ">>>---关闭hadoop"
    /home/$USER/datawarehouse_project/script/cluster_hadoop_control.sh stop
    
    echo ">>>---关闭zookeeper"
    /home/$USER/datawarehouse_project/script/cluster_zookeeper_control.sh stop

    echo ">>>--- stop completed!"
}


case $1 in
    "start"){
        start;
    };;
    "stop"){
        stop;
    };;
    "restart"){
        stop;
        start;
    };;
    *){
        echo "请正确输入参数(start-启动;stop-停止)"
        exit
    };;
esac
