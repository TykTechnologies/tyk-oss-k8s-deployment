# Tyk OSS Deployment

This contains deployment files to run a Tyk GW with Redis in a kubernetes cluster.

1. Clone this directory:
```
$ git clone git@github.com:TykTechnologies/tyk-oss-k8s-deployment.git
```

2. To install, just run the following command from within the directory:
```
$ kubectl apply -f .
configmap/tyk-gateway-conf created
deployment.apps/tyk-gtw created
service/tyk-svc created
deployment.apps/redis created
service/redis created
```

3. Check logs to ensure its running

```
$ kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
redis-7bb4df7c8c-2565f    1/1     Running   0          36s
tyk-gtw-bb7b74677-k9jx9   1/1     Running   0          36s

$ kubectl logs tyk-gtw-bb7b74677-k9jx9

...
time="Dec 04 19:19:39" level=info msg="API Loaded" api_id=1 api_name="Tyk Test API" org_id=default prefix=gateway server_name=-- user_id=-- user_ip=--
time="Dec 04 19:19:39" level=info msg="Loading uptime tests..." prefix=host-check-mgr
time="Dec 04 19:19:39" level=info msg="Initialised API Definitions" prefix=main
time="Dec 04 19:19:39" level=info msg="API reload complete" prefix=main
```

4. To access the gateway run 
$ `kubectl port-forward svc/tyk-svc 8080:8080` 

We see that now our Gateway is ready to accept requests.  Use the [Gateway REST API](https://tyk.io/docs/tyk-gateway-api/) to create your first API
OR, use the [Tyk-Operator](https://github.com/TykTechnologies/tyk-operator) to declaratively create and manage your API definitions using the kubectl cli.

## Tyk REST APIS

Following please find a few apis to help you getting started quickly

1. Create an api
  1. Check the current APIs:
    `curl -s -H "x-tyk-authorization: foo" http://localhost:8080/tyk/apis  | jq '.[]| { api_id: .api_id, name: .name, listen_path: .proxy.listen_path }'`

  2. Create a new api
    ```
    $ curl -s  -H "x-tyk-authorization: foo" http://localhost:8080/tyk/apis/ -d @my-api -X POST | jq .
    {
      "key": "2",
      "status": "ok",
      "action": "added"
    }
    ```

  3. If you check the list of APIs again ,you'll see no change. You need to hot reload the gateway so it'll start listening to the new api
  ```
  $ curl -s -H "x-tyk-authorization: foo" http://localhost:8080/tyk/reload | jq .
  {
    "status": "ok",
    "message": ""
  } 
  ```
 
  4. Now you can call `/tyk/apis` again and see your new api in the list

  5. Try to call the api, you'll get 403, continue to step `#2 Create a key`
  ```
  $ curl -s http://localhost:8080/my-api/ip
  {
    "error": "Authorization field missing"
  }
  ```

2. Create a key 

  ```
  $ curl -s -H "x-tyk-authorization: foo" http://localhost:8080/tyk/keys/create -d @key-of-my-api | jq .
  {
    "key": "<you-new-key>",
    "status": "ok",
    "action": "added",
    "key_hash": "889abc9c"
  }
  ```

3. Try to call the api again, with the new key from step #2

  ```
  $ curl  http://localhost:8080/my-api/ip -H "Authorization: <you-new-key>"
  {
    "origin": "127.0.0.1, 90.252.81.14"
  }
  ```

To delete the API run:
```
curl  -H "x-tyk-authorization: foo" http://localhost:8080/tyk/apis/2 -X DELETE
```

## Tyk Operator

If combining with [Tyk Operator]((https://github.com/TykTechnologies/tyk-operator)), you can use the following secret config to have the Tyk Operator control the Tyk Gateway using the K8S DNS name.  Follow the install instructions for Tyk Operator if this doesn't make sense.

```
kubectl create secret -n tyk-operator-system generic tyk-operator-conf \
  --from-literal "TYK_AUTH=foo" \
  --from-literal "TYK_ORG=oss" \
  --from-literal "TYK_MODE=oss" \
  --from-literal "TYK_URL=http://tyk-svc.default.svc.cluster.local:8080"
```
