echo Running scripts...

echo Setting up cluster...
kind create cluster --name otot-task-a2 --config kind/cluster-config.yaml

docker ps

kubectl get nodes --context kind-otot-task-a2

kubectl cluster-info --context kind-otot-task-a2

sleep 10

echo Setting up Deployment of node app...

kubectl apply -f manifests/k8s/backend-deployment.yaml --context kind-otot-task-a2 

kubectl wait --for=condition=ready pod --selector=app=backend --timeout=300s --context kind-otot-task-a2

kubectl get po -l app=backend -o wide --context kind-otot-task-a2

kubectl get deploy/backend

echo Setting up Service of node app...

kubectl apply -f manifests/k8s/backend-service.yaml --context kind-otot-task-a2

kubectl describe svc backend-service --context kind-otot-task-a2

echo Setting up Ingress controller...

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml --context kind-otot-task-a2

kubectl wait -n ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=150s --context kind-otot-task-a2
kubectl -n ingress-nginx get po -l app.kubernetes.io/component=controller -o wide --context kind-otot-task-a2

kubectl -n ingress-nginx get deploy --context kind-otot-task-a2

echo Sleep 5s to wait
sleep 5

echo Setting up Ingress object...

kubectl apply -f manifests/k8s/backend-ingress.yaml --context kind-otot-task-a2

kubectl get ingress -l app=backend -o wide --context kind-otot-task-a2

echo Testing curl after 10s

sleep 10

curl http://localhost/

echo Done!
