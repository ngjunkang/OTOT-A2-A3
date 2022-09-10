echo Creating metrics server
kubectl apply -f manifests/k8s/metrics-server.yaml --context kind-otot-task-a2

kubectl -n kube-system get deploy --selector=k8s-app=metrics-server

echo Starting hpa
kubectl apply -f manifests/k8s/backend-hpa.yaml --context kind-otot-task-a2

echo Done!