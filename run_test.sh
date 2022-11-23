#!/bin/bash

# -------------------------
# -------- ORIENTDB --------
# -------------------------

cd targetDB/data

# start services defined in docker-compose-orientdb.yml
docker-compose -f docker-compose-orientdb.yml up -d 

cd ../../YCSB/ycsb-0.17.0

# run orientdb three times on workload a - save output in directory results/orientdb/workload_A
for iter in {1..3}
    do
        bin/ycsb.sh load orientdb -P workloads/workloada -p orientdb.url=plocal:localhost:2480 -p orientdb.password=admin > ../../results/orientdb/workload_A/output_load${iter}
        bin/ycsb.sh run orientdb -P workloads/workloada -p orientdb.url=plocal:localhost:2480 -p orientdb.password=admin > ../../results/orientdb/workload_A/output_run${iter}
    done

# run orientdb three times on workload b – save output in directory results/orientdb/workload_B
for iter in {1..3}
    do
        bin/ycsb.sh load orientdb -P workloads/workloadb -p orientdb.url=plocal:localhost:2480 -p orientdb.password=admin > ../../results/orientdb/workload_B/output_load${iter}
        bin/ycsb.sh run orientdb -P workloads/workloadb -p orientdb.url=plocal:localhost:2480 -p orientdb.password=admin > ../../results/orientdb/workload_B/output_run${iter}
    done

cd ../../targetDB/data

# stop services defined in docker-compose-orientdb.yml
docker-compose -f docker-compose-orientdb.yml down


# -------------------------
# -------- MONGODB --------
# -------------------------

cd ../..

# start mongodb docker containers
./mongo_setup.sh

cd YCSB/ycsb-0.17.0

# run mongodb three times on workload a - save output in directory results/mongodb/workload_A
for iter in {1..3}
    do
    ./bin/ycsb.sh load mongodb -s -P workloads/workloada -p mongodb.url=mongodb://127.0.0.1:27017/ycsb?w=1 > ../../results/mongodb/workload_A/output_load${iter}
    ./bin/ycsb.sh run mongodb -s -P workloads/workloada -p mongodb.url=mongodb://127.0.0.1:27017/ycsb?w=1 > ../../results/mongodb/workload_A/output_run${iter}
    done

# run mongodb three times on workload b - save output in directory results/mongodb/workload_B
for iter in {1..3}
    do
    ./bin/ycsb.sh load mongodb -s -P workloads/workloadb -p mongodb.url=mongodb://127.0.0.1:27017/ycsb?w=1 > ../../results/mongodb/workload_B/output_load${iter}
    ./bin/ycsb.sh run mongodb -s -P workloads/workloadb -p mongodb.url=mongodb://127.0.0.1:27017/ycsb?w=1 > ../../results/mongodb/workload_B/output_run${iter}
    done

# stops mongodb docker containers
docker stop $(docker ps -a -q)

# removes mongodb docker network
docker network rm mongoCluster
 