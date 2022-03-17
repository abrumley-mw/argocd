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

echo "Current argocd Admin password: is test-cna "


echo 
echo "Logging on to ArgoCD..."
argocd login localhost:8080


#install rollouts:
echo "Applying Rollouts manifest to cluster:"
kubectl apply -n argocd -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
#create app
echo "Creating app"
argocd app create guestbook-ui-bg --repo https://github.com/abrumley-mw/argocd.git --path austin-argocd/apps/blue-green --dest-server https://kubernetes.default.svc --dest-namespace argocd