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