#! /bin/bash

buried_log_data_generate_path="/home/$USER/datawarehouse_project/data/simulation_data/log_data/buried_log_data_generate"
application_properties_path="$buried_log_data_generate_path/application.properties";

# 如果输入参数个人等于1个，
if [ $# -eq 1 ]
then
    sed -i "4s/[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}/$1/g" $application_properties_path

    cd $buried_log_data_generate_path;

    # java -jar $buried_log_data_generate_path/gmall2020-mock-log-2020-05-10.jar >/dev/null 2>&1 &
    java -jar $buried_log_data_generate_path/gmall2020-mock-log-2020-05-10.jar


    echo "Data generate completed!"
else
    echo "请输入业务日期，使用方式为: $0 2022-08-09"
fi

