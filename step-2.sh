#!/usr/bin/env bash
echo "--kubectl apply -f nginx-deployment.yml"
kubectl apply -f nginx-deployment.yml
echo "--kubectl get po,rs"
kubectl get po,rs
echo "--Verify that the replicaset is created but not the pod. Enter to continue."
read var
echo "--kubectl describe rs $(kubectl get rs | grep nginx-deployment | awk '{print $1}')"
kubectl describe rs $(kubectl get rs | grep nginx-deployment | awk '{print $1}')
echo "--Take a look at why the pod creation failed. Enter to proceed and delete the deployment."
read var
echo "--Deleting the deployment"
echo "--kubectl delete deploy nginx-deployment"
kubectl delete deploy nginx-deployment
echo "--Try creating pod manually using admin user"
echo "--kubectl run nginx --image=nginx --restart=Never"
kubectl run nginx --image=nginx --restart=Never
echo "--kubectl get po"
kubectl get po
echo "--Enter to proceed and delete the pod"
read var
echo "--kubectl delete pod nginx --now"
kubectl delete pod nginx --now
echo "--kubectl get po"
kubectl get po
echo "--step-2 complete"
