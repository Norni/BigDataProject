#! /bin/bash

if [ $# -lt 1 ]
then 
    echo "请正确输入参数: start-启动集群;stop-关闭集群"
    exit;
fi


case $1 in
    "start")
        echo ">>>--- 启动集群"
        echo ">>>--- 启动历史服务器..."
        ssh node001 "mapred --daemon start historyserver"
        echo ">>>--- 启动HDFS..."
        ssh node001 "$HADOOP_HOME/sbin/start-dfs.sh"
        echo ">>>--- 启动YARN..."
        ssh node002 "$HADOOP_HOME/sbin/start-yarn.sh"
    ;;
    "stop")
        echo ">>>--- 关闭集群"
        echo ">>>--- 关闭HDFS..."
        ssh node001 "$HADOOP_HOME/sbin/stop-dfs.sh"
        echo ">>>--- 关闭YARN..."
        ssh node002 "$HADOOP_HOME/sbin/stop-yarn.sh"
        echo ">>>--- 关闭历史服务器..."
        ssh node001 "mapred --daemon stop historyserver"
    ;;
    *)
        echo "请正确输入参数: start-启动集群;stop-关闭集群"
    ;;
esac