# Tyk OSS Deployment

This contains deployment files to run a Tyk GW with Redis in a kubernetes cluster.

1. Clone this directory:
```
$ git clone TykTechnologies/tyk-oss-k8s-deployment
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

We see that now our Gateway is ready to accept requests.  Use the [Gateway REST API](https://tyk.io/docs/tyk-gateway-api/) to create your first API
OR, use the [Tyk-Operator](https://github.com/TykTechnologies/tyk-operator) to declaratively create and manage your API definitions using the kubectl cli.

## Tyk Operator

If combining with [Tyk Operator]((https://github.com/TykTechnologies/tyk-operator)), you can use the following secret config to have the Tyk Operator control the Tyk Gateway using the K8S DNS name.  Follow the install instructions for Tyk Operator if this doesn't make sense.

```
kubectl create secret -n tyk-operator-system generic tyk-operator-conf \
  --from-literal "TYK_AUTH=foo" \
  --from-literal "TYK_ORG=oss" \
  --from-literal "TYK_MODE=oss" \
  --from-literal "TYK_URL=http://tyk-svc.default.svc.cluster.local:8080"
```
