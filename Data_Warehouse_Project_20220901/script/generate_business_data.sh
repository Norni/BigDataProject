#! /bin/bash


if [ -n "$2" ]
then
    now_date=$2
else
    now_date=`date -d "-1 day" "+%F"`
fi


function generate_data(){
# 修改重置标注
sed -i "18s/[0-9]\{1\}/$1/g" $application_properties_path;
# 传入初始业务日期
sed -i "16s/[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}/$2/g" $application_properties_path;
# 执行数据生成程序
cd $business_data_generate_path;
java -jar $business_data_generate_path/gmall2020-mock-db-2020-05-18.jar
}



if [ $# -eq 2 ]
then
    business_data_generate_path="/home/$USER/datawarehouse_project/data/simulation_data/business_data/business_data_generate"
    application_properties_path="$business_data_generate_path/application.properties"

    case $1 in
    "first_generate"){
        generate_data 1 $2
        echo "data has been initialized!"
    };;
    "second_generate"){
        generate_data 0 $2
        echo "data has been added!"
    };;
    *){
        echo "脚本使用方式： $0 first_generate|second_generate xxxx-xx-xx";
    };;
    esac
else
    echo "脚本使用方式： $0 first_generate|second_generate xxxx-xx-xx";
fi





