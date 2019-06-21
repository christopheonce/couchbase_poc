package main

import "fmt"
import cb "github.com/couchbase/gocb"

type couchbaseService struct {
	Bucket *cb.Bucket
}

func newCouchbaseService() *couchbaseService {
	cluster, _ := cb.Connect("couchbase://localhost")
	bucket, err := cluster.OpenBucket("default", "")
	if err != nil {
		panic(fmt.Sprintf("Could not connect to bucket %v", err))
	}
	return &couchbaseService{Bucket: bucket}
}

func main() {
	service := newCouchbaseService()
	service.Bucket.Upsert("key", "string", 0)
}
