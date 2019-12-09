#!/usr/bin/env bash
echo "--Cluster role binding associates service account(s), user(s), group(s) to a cluster role."

echo "--First, we will create a role binding that will apply to all service accounts in kube-system namespace."
echo "--These service accounts are used by the controllers (such as replication controller) to create pods."
echo "--Please note that only service accounts are referred to from the kube-system namespace, the role and rolebinding are in the default namespace"

echo ""
echo "--kubectl apply -f crb-restrictive.yml"
kubectl apply -f crb-restrictive.yml
echo "--Enter to continue"
read var

echo "--kubectl get clusterrole,clusterrolebinding -l type=madhav-psp"
kubectl get clusterrole,clusterrolebinding -l type=madhav-psp

echo ""
echo "--Enter to continue"
read var

echo "--Now we will try to create the nginx deployment and see if the pod creation is successful this time."
echo "--First let us delete the deployment to ensure there is no previous deployment hanging around."
echo ""
echo "--Enter to continue"
read var
echo "--kubectl delete deploy nginx-deployment"
kubectl delete deploy nginx-deployment

echo ""
echo "--Enter to continue"
read var

echo "--kubectl get deploy,rs,po"
kubectl get deploy,rs,po

echo ""
echo "--Enter to continue"
read var

echo "--kubectl apply -f nginx-deployment.yml"
kubectl apply -f nginx-deployment.yml

echo ""
echo "--Enter to continue"
read var

echo "--kubectl get rs,po"
kubectl get rs,po

echo ""
echo "--Do you see the Pod? YES! You should see the Pod now if you did everything right."
echo "--If Not you likely have the deployment of the previous step still running. So delete it and try again"

echo "--Enter to continue"
read var

echo "--Delete the deployment"
echo ""
echo "--Enter to continue"
read var
echo "--kubectl delete deploy nginx-deployment"
kubectl delete deploy nginx-deployment
echo ""
echo "--Enter to continue"
read var
echo "--kubectl get deploy,rs,po"
kubectl get deploy,rs,po

echo ""
echo "--Enter to continue"
read var

echo "--step-6 complete"