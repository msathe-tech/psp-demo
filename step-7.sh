#!/usr/bin/env bash
echo "--Now we will try to create a deployment with privileged access."
echo "--In this case we are trying to get access to Host's network."
echo "--Enter to continue"
read var

echo ""
echo "--kubectl apply -f nginx-deployment-hostnw.yml"
kubectl apply -f nginx-deployment-hostnw.yml

echo ""
echo "--Verify if the new pod got created."
echo "--kubectl get rs,po"
kubectl get rs,po

echo ""
echo "--Check why the pod creation failed for new deployment."
echo "--Enter to continue"
read var

echo "--kubectl describe rs $(kubectl get rs | grep nginx-deployment-hostnw | awk '{print $1}')"

kubectl describe rs $(kubectl get rs | grep nginx-deployment-hostnw | awk '{print $1}')

echo ""
echo "--This is expected. The replicaset controller only has access to 'restrictive' pod security policy."
echo "--You shouldn't require to use host's network for most of your applications."

echo "--Enter to delete the deployment"
read var

echo "--kubectl delete deploy nginx-deployment-hostnw"
kubectl delete deploy nginx-deployment-hostnw
echo ""
echo "--Enter to continue"
read var

echo "--kubectl get deploy,rs,po"
kubectl get deploy,rs,po

echo "--Enter to continue"
read var

echo "--step-7 complete"