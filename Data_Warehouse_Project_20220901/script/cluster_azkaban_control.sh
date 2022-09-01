#! /bin/bash

executor_path="/opt/software/azkaban/azkaban-exec-server-3.84.4"
web_path="/opt/software/azkaban/azkaban-web-server-3.84.4"

function start_exec(){
    for host in node001 node002 node003
    do
        ssh $host "cd $executor_path; ./bin/start-exec.sh; sleep 1s;"
    done
}

function stop_exec(){
    for host in node001 node002 node003
    do
        ssh $host "cd $executor_path; ./bin/shutdown-exec.sh"
    done
}

function start_web(){
    for host in node001
    do
        ssh $host "cd $web_path; ./bin/start-web.sh"
    done
}

function stop_web(){
    for host in node001
    do
        ssh $host "cd $web_path; ./bin/shutdown-web.sh"
    done
}


function activate_exec(){
    for host in node001 node002 node003
    do
        ssh $host "curl -G '$host:$(< $executor_path/executor.port)/executor?action=activate' && echo"
    done
}


case $1 in 
"start_exec"){
    start_exec;
};;
"stop_exec"){
    stop_exec;
};;
"start_web"){
    start_web;
};;
"stop_web"){
    stop_web;
};;
"activate_exec"){
    activate_exec;
};;
"start"){
    start_exec;
    sleep 2s;
    activate_exec;
    sleep 2s;
    start_web;
};;
"stop"){
    stop_web;
    sleep 1s;
    stop_exec;
};;
*){
    echo "tips: $0 start|stop|start_exec|stop_exec|start_web|stop_web|activate_exec";
};;
esac


