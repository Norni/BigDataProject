#! /bin/bash


if [ $# -lt 1 ]
then
    echo "请输入待同步的文件路径!";
    exit 1;
fi


# 获取集群host
cluster_hosts_path=/home/$USER/datawarehouse_project/conf/shell/cluster_hosts/host.txt

# 遍历集群
for host in `cat $cluster_hosts_path`
do
    # 跳过本机
    if [ $HOSTNAME != $host ]
    then
        echo ">>>--- current host: $host"
        for file in $@
        do
            if [ -e $file ]
            then
                # 获取父目录
                pdir=$(cd -P $(dirname $file);pwd)
                # 获取文件名称
                fname=$(basename $file)
                # 对目标host的filename创建对应的父目录
                ssh $host "mkdir -p $pdir"
                # 同步文件
                rsync -av $pdir/$fname $host:$pdir
            else
                echo "待同步文件 $file 不存在"
            fi
        done
    fi
done
