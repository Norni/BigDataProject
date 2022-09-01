#! /bin/bash


if [ $# -lt 1 ]
then
    echo "请输入足够的参数!"
    exit;
fi

# 获取集群host
cluster_hosts_path=/home/$USER/datawarehouse_project/conf/shell/cluster_hosts/host.txt

# 遍历集群
for host in `cat $cluster_hosts_path`
do
    echo ">>>--- current host: $host"
    ssh $host "$*"
done
