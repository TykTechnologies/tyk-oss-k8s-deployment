#!/bin/bash

# Deploy API Clarity into own namespace using Helm
kubectl create namespace apiclarity --dry-run=client -o yaml | kubectl apply -f -
helm repo add apiclarity https://apiclarity.github.io/apiclarity
helm install --values values.yaml apiclarity apiclarity/apiclarity -n apiclarity