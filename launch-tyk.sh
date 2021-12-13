#!/bin/bash

# Deploy Tyk & Redis
kubectl create namespace tyk --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f . -n tyk