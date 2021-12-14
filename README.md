# Tyk OSS Deployment

This contains deployment files to run 
- Tyk OSS 
- APIClarity

1. Clone this directory:
```
$ git clone git@github.com:TykTechnologies/tyk-oss-k8s-deployment.git
```

2. Deploy Tyk into k8s cluster in `tyk` namespace
```
$ ./launch-tyk.sh

<bunch of resources created>
```

3. Deploy APIClarity into own namespace in k8s cluster using Helm
```
$ ./apiclarity.sh 

"apiclarity" has been added to your repositories
Error: failed post-install: job failed: BackoffLimitExceeded
```
give it a second to spin up, you can ignore the last error.

4. Port-forward to Tyk & APIClarity
```
$ kubectl -n tyk port-forward svc/tyk-svc 8080:8080
Forwarding from 127.0.0.1:8080 -> 8080
Forwarding from [::1]:8080 -> 8080
```

On different terminal:
```
$ kubectl port-forward -n apiclarity svc/apiclarity-apiclarity 9999:8080
Forwarding from 127.0.0.1:9999 -> 8080
Forwarding from [::1]:9999 -> 8080
```

Run the test suite to generate API calls against Tyk
```
$ ./generate-apicalls.sh
```


## Known Bugs

1. GET curls to `httpbin/xml` don't get picked up by APIClarity
2. The helm (false) error output when installing APIClarity: 
```
Error: failed post-install: job failed: BackoffLimitExceeded
```