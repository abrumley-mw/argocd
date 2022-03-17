#!/bin/bash


echo "Open a new terminal, and run: kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo
read -p "Did you start port forwarding in a new terminal? (y, N) " pf
if [[ $pf == "y" || $pf == "Y" ]]
then
    echo "Great! Continuing..."
else
    echo "Port forwarding not set. Exiting..."
    exit 0
fi

helm repo add argo https://argoproj.github.io/argo-helm
helm -n argocd upgrade --install --create-namespace argocd argo/argo-cd -f argocd/helm/values.yaml --wait
helm -n argocd install argo-release argo/argo-rollouts

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
echo "Current argocd Admin password: is test-cna "
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

echo 
echo "Logging on to ArgoCD..."
argocd login localhost:8080
argocd account update-password

#install rollouts:
echo "Applying Rollouts manifest to cluster:"
kubectl apply -n argocd -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
#create app
echo "Creating app"
argocd app create blue-green --repo https://github.com/abrumley-mw/argocd.git --path austin-argocd/apps/blue-green --dest-server https://kubernetes.default.svc --dest-namespace argo-rollouts