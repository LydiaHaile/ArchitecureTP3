#!/bin/sh

# pulling mongodb image - is this needed each time? 
docker pull mongo
# creates network so the containers can see each other
docker network create mongoCluster

# starts three conntainers with MongoDB named mongo1, mongo2, mongo3
docker run -d --rm -p 27017:27017 --name mongo1 --network mongoCluster mongo:5 mongod --replSet myRS --bind_ip localhost,mongo1
docker run -d --rm -p 27018:27017 --name mongo2 --network mongoCluster mongo:5 mongod --replSet myRS --bind_ip localhost,mongo2
docker run -d --rm -p 27019:27017 --name mongo3 --network mongoCluster mongo:5 mongod --replSet myRS --bind_ip localhost,mongo3

# initiates the replica set
# wintpy is used for windows OS
docker exec -it mongo1 mongosh --eval "rs.initiate({
 _id: 'myRS',
 members: [
   {_id: 0, host: 'mongo1:27017'},
   {_id: 1, host: 'mongo2:27017'},
   {_id: 2, host: 'mongo3:27017'}
 ]
})"

#cd YCSB/ycsb-0.17.0

#load workload syncdriver
#./bin/ycsb.sh load mongodb -s -P workloads/workloada -p mongodb.url=mongodb://127.0.0.1:27017/ycsb?w=1 > ../outputLoad1.txt
# run workload
#./bin/ycsb.sh run mongodb -s -P workloads/workloada -p mongodb.url=mongodb://127.0.0.1:27017/ycsb?w=1 > ../outputRun.txt 

# for iter in {1..3}
# do
#   ./bin/ycsb.sh load mongodb -s -P workloads/workloada -p mongodb.url=mongodb://127.0.0.1:27017/ycsb?w=1 > ../../results/mongodb/workload_A/output_load${iter}
#   ./bin/ycsb.sh run mongodb -s -P workloads/workloada -p mongodb.url=mongodb://127.0.0.1:27017/ycsb?w=1 > ../../results/mongodb/workload_A/output_run${iter}
# done

# for iter in {1..3}
# do
#   ./bin/ycsb.sh load mongodb -s -P workloads/workloadb -p mongodb.url=mongodb://127.0.0.1:27017/ycsb?w=1 > ../../results/mongodb/workload_B/output_load${iter}
#   ./bin/ycsb.sh run mongodb -s -P workloads/workloadb -p mongodb.url=mongodb://127.0.0.1:27017/ycsb?w=1 > ../../results/mongodb/workload_B/output_run${iter}
# done

# #stops containers
# docker stop $(docker ps -a -q)

# #removes network
# docker network rm mongoCluster
