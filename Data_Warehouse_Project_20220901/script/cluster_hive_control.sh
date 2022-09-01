#! /bin/bash

HIVE_LOG_DIR=$HIVE_HOME/logs

if [ ! -d $HIVE_LOG_DIR ]
    then
        mkdir -p $HIVE_LOG_DIR
fi

# 检查进程是否正常运行，参数1为进程名，参数2为进程端口
function check_process(){
    # 1 通过查看进程ps，获取pid
    ps_pid=$( ps -ef 2>/dev/null | grep -v grep | grep -i $1 | awk '{print $2}' );

    # 2 通过查看网络端口，获取pid
    netstat_pid=$( netstat -nltp 2>/dev/null | grep $2 | awk '{print $7}' | cut -d/ -f1 );

    # 3 输出状态
    # echo "===>>> 当前服务$1: ps -ef获取的pid=$ps_pid  ; netstat -nltp获取的pid=$netstat_pid";

    # 4 检查获取到的pid，判断服务是否启动，成功则返回0，否则返回1
    if [[ -n "$ps_pid" ]] && [[ -n "$netstat_pid" ]] && [[ "$ps_pid"="$netstat_pid" ]]
        then
            return 0
    else
        return 1
    fi
}

function hiveserver_start(){
    check_process HiveMetaStore 9083;
    ck_hivemetastore_result=$?;
    check_process HiveServer2 10000;
    ch_hiveserver2_result=$?;
    if [[ "$ck_hivemetastore_result" -eq "0" ]] && [[ "$ch_hiveserver2_result" -eq "0" ]]
        then
            echo ">>>--- HiveMetaStore 服务已存在，无需再次启动"
            echo ">>>--- HiveServer2 服务已存在，无需再次启动";
    else
        # 通过服务名获取进行pid，并杀死进程
        hivemetastore_pid=$( ps -ef | grep -v grep | grep -i HiveMetaStore | awk '{print $2}' );
        eval "kill -9 $hivemetastore_pid >/dev/null 2>&1";
        # 启动HiveMetaStore获取，并将输出写入日志文件
        log_filename="$HIVE_LOG_DIR/hivemetastore_$(date +%Y_%m_%d).log";
        eval "nohup hive --service metastore >> $log_filename 2>&1 &";
        echo ">>>--- HiveMetaStore 服务已启动";

        hiveserver2_pid=$( ps -ef | grep -v grep | grep -i HiveServer2 | awk '{print $2}' );
        eval "kill -9 $hiveserver2_pid > /dev/null 2>&1";
        log_filename="$HIVE_LOG_DIR/hiveserver2_$(date +%Y_%m_%d).log";
        eval "nohup hive --service hiveserver2 >> $log_filename 2>&1 &";
        echo ">>>--- HiveServer2 服务已启动";
    fi
}


function hiveserver_stop(){
    check_process HiveMetaStore 9083;
    ck_hivemetastore_result=$?;
    check_process HiveServer2 10000;
    ch_hiveserver2_result=$?;
    if [[ "$ck_hivemetastore_result" -eq "1" ]] && [[ "$ch_hiveserver2_result" -eq "1" ]]
        then
            echo ">>>--- HiveMetaStore 服务已关闭,无需再次关闭"
            echo ">>>--- HiveServer2 服务已关闭，无需再次关闭";
    else
        # 通过服务名获取进行pid，并杀死进程
        hivemetastore_pid=$( ps -ef | grep -v grep | grep -i HiveMetaStore | awk '{print $2}' );
        eval "kill -9 $hivemetastore_pid > /dev/null 2>&1";
        echo ">>>--- HiveMetaStore 服务已关闭";

        hiveserver2_pid=$( ps -ef | grep -v grep | grep -i HiveServer2 | awk '{print $2}' );
        eval "kill -9 $hiveserver2_pid > /dev/null 2>&1";
        echo ">>>--- HiveServer2 服务已关闭";
    fi
}



case $1 in
"start")
    hiveserver_start;
    sleep 5s;
;;
"stop")
    hiveserver_stop;
    sleep 5s;
;;
"restart")
    hiveserver_stop;
    sleep 5s;
    hiveserver_start;
    sleep 5s;
;;
"status")
    check_process HiveMetastore 9083 >/dev/null && echo "Metastore 服务运行正常" || echo "Metastore 服务运行异常";
    check_process HiveServer2 10000 >/dev/null && echo "HiveServer2 服务运行正常" || echo "HiveServer2 服务运行异常";
;;
*)
    echo "Usage: $0 start|stop|restart|status";
;;
esac
