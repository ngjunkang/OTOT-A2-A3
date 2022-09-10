echo Running scripts...

echo Setting up cluster...
kind create cluster --name otot-task-a3 --config kind/cluster-config.yaml

docker ps

kubectl get nodes --context kind-otot-task-a3

kubectl cluster-info --context kind-otot-task-a3

sleep 10

echo Setting up Deployment of node app...

kubectl apply -f manifests/k8s/backend-zone-aware.yaml --context kind-otot-task-a3 

kubectl wait --for=condition=ready pod --selector=app=backend-zone-aware --timeout=300s --context kind-otot-task-a3

kubectl get po -l app=backend-zone-aware -o wide --context kind-otot-task-a3

kubectl get deploy/backend-zone-aware

echo Setting up Service of node app...

kubectl apply -f manifests/k8s/backend-service-zone-aware.yaml --context kind-otot-task-a3

kubectl describe svc backend-service-zone-aware --context kind-otot-task-a3

echo Setting up Ingress controller...

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml --context kind-otot-task-a3

kubectl wait -n ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=150s --context kind-otot-task-a3
kubectl -n ingress-nginx get po -l app.kubernetes.io/component=controller -o wide --context kind-otot-task-a3

kubectl -n ingress-nginx get deploy --context kind-otot-task-a3

echo Sleep 5s to wait
sleep 5

echo Setting up Ingress object...

kubectl apply -f manifests/k8s/backend-ingress-zone-aware.yaml --context kind-otot-task-a3

kubectl get ingress -l app=backend-zone-aware -o wide --context kind-otot-task-a3

echo Testing curl after 10s

sleep 10

curl http://localhost/

kubectl get po -lapp=backend-zone-aware -owide --sort-by='.spec.nodeName'

echo Done!
