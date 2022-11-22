#!/bin/bash
cd /home/ubuntu
sudo apt-get update
yes | sudo apt-get upgrade

yes | sudo apt install openjdk-11-jdk-headless
wget https://dlcdn.apache.org/hbase/stable/hbase-2.4.15-bin.tar.gz
tar xzvf hbase-2.4.15-bin.tar.gz
cd hbase-2.4.15
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/
bin/start-hbase.sh
jps

curl -O --location https://github.com/brianfrankcooper/YCSB/releases/download/0.17.0/ycsb-0.17.0.tar.gz
tar xfvz ycsb-0.17.0.tar.gz
# cd ycsb-0.17.0

./bin/hbase shell

# in the new shell
n_splits = 200 # HBase recommends (10 * number of regionservers)
create 'usertable', 'family', {SPLITS => (1..n_splits).map {|i| "user#{1000+i*(9999-1000)/n_splits}"}}

"""yes | sudo apt install default-jre
yes | sudo apt install default-jdk
wget https://dlcdn.apache.org/hbase/stable/hbase-2.4.15-bin.tar.gz
tar xzvf hbase-2.4.15-bin.tar.gz
cd hbase-2.4.15
#export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/
#bin/start-hbase.sh"""