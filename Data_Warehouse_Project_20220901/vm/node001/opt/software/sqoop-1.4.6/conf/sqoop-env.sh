# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# included in all the hadoop scripts with source command
# should not be executable directly
# also should not be passed any arguments, since we need original $*

# Set Hadoop-specific environment variables here.

#Set path to where bin/hadoop is available
#export HADOOP_COMMON_HOME=
export HADOOP_COMMON_HOME=/opt/software/hadoop-3.2.2

#export HADOOP_MAPRED_HOME=
export HADOOP_MAPRED_HOME=/opt/software/hadoop-3.2.2

#set the path to where bin/hbase is available
#export HBASE_HOME=

#Set the path to where bin/hive is available
#export HIVE_HOME=
export HIVE_HOME=/opt/software/hive-3.1.2

#Set the path for where zookeper config dir is
#export ZOOCFGDIR=
export ZOOKEEPER_HOME=/opt/software/zookeeper-3.5.7
export ZOOCFGDIR=/opt/software/zookeeper-3.5.7/conf
