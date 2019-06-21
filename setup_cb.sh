#!/bin/sh

docker stop db
docker run -d --name db --rm -p 8091-8094:8091-8094 -p 11210:11210 -m=2048m couchbase:4.5.1

echo "Let s wait a bit for couchbase to be up and running"
sleep 15

echo "Sending node settings"
curl -i 'http://localhost:8091/nodes/self/controller/settings' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8'  --data 'path=%2Fopt%2Fcouchbase%2Fvar%2Flib%2Fcouchbase%2Fdata&index_path=%2Fopt%2Fcouchbase%2Fvar%2Flib%2Fcouchbase%2Fdata' | grep HTTP

echo "Setup default bucket"
curl -i 'http://localhost:8091/pools/default/buckets' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' --data 'bucketType=membase&ramQuotaMB=512&name=default&evictionPolicy=valueOnly&authType=sasl&saslPassword=&replicaNumber=1&replicaIndex=0&threadsNumber=3&flushEnabled=0&otherBucketsRamQuotaMB=0&conflictResolutionType=seqno' | grep HTTP


echo "Setup login/password"
curl 'http://localhost:8091/settings/web'  -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' --data 'username=Administrator&password=Administrator&port=SAME' | grep HTTP
