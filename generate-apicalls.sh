#!/bin/bash

echo Generating load against two APIs.

for i in {1..5}; do    
    # JsonPlaceholder API
    curl -s localhost:8080/jsonplaceholder/users/$i &
    curl -s localhost:8080/jsonplaceholder/posts/$i &
    curl -s localhost:8080/jsonplaceholder/comments/$i &
    # Not documented in API spec
    # APIClarity will alert this:
    curl -s localhost:8080/jsonplaceholder/users/$i/posts &

    # Let APIClarity reconstruct this:
    curl -s localhost:8080/httpbin/get &
    curl -s localhost:8080/httpbin/post -X POST &
    curl -s localhost:8080/httpbin/xml &
    curl -s localhost:8080/httpbin/json &
    curl -s localhost:8080/httpbin/headers &
    curl -s localhost:8080/httpbin/delete -X DELETE &
done

echo Finished generating load against two APIs.