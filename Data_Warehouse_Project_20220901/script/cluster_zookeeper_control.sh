#! /bin/bash

if [ $# -lt 1 ] 
then
    echo "请输入参数: start-启动;stop-停止;status-查看状态";
    exit;
fi


function start(){
    ssh $1 '/opt/software/zookeeper-3.5.7/bin/zkServer.sh start';
    return $?;
}

function stop(){
    ssh $1 '/opt/software/zookeeper-3.5.7/bin/zkServer.sh stop';
    return $?;
}

function status(){
    ssh $1 '/opt/software/zookeeper-3.5.7/bin/zkServer.sh status';
    return $?;
}


# 获取集群host
cluster_hosts_path=/home/$USER/datawarehouse_project/conf/shell/cluster_hosts/host.txt


case $1 in
    "start"){
        for host in `cat $cluster_hosts_path`
        do
            echo ">>>--- current host: $host";
            start $host;
        done
    };;
    "stop"){
        for host in `cat $cluster_hosts_path`
        do
            echo ">>>--- current host: $host";
            stop $host;
        done
    };;
    "status"){
        for host in `cat $cluster_hosts_path`
        do
            echo ">>>--- current host: $host";
            status $host;
        done
    };;
    *){
        echo "请输入参数: start-启动;stop-停止;status-查看状态";
        exit;
    };;
esac