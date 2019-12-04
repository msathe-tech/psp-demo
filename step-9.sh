#!/usr/bin/env bash

echo "--In Step 8 we saw how the 'nginx-deployment-hostnw' deployment failed in the default namespace."
echo "--We want to avoid giving blanket permission to start privileged containers in the default namespace."
echo "--However, we may have one particular app that may require such a privilege."
echo "--In that case you can create a separate service account and specify that in the app deployment."
echo "--This service account can be given the required role within the namespace."

echo ""
echo "--Enter to continue"
read var
echo "--Create a service account."

echo "kubectl create sa specialsa"
kubectl create sa specialsa

echo ""
echo "--Enter to continue"
read var

echo "--Now, create the role binding for this service account."

echo "kubectl apply -f rb-permissive-sa.yml"
kubectl apply -f rb-permissive-sa.yml

echo ""
echo "--Enter to continue"
read var
echo "kubectl get rolebinding"
kubectl get rolebinding

echo ""
echo "--Time to test."
echo ""
echo "--Enter to continue"
read var

echo "kubectl apply -f nginx-deployment-hostnw-sa.yml"
kubectl apply -f nginx-deployment-hostnw-sa.yml
echo ""
echo "--Enter to continue"
read var

echo "kubectl get rs,po"
kubectl get rs,po
echo ""
echo "--Can you the see Pod here? YES!"
echo "--The deployment is able to create privileged container because the service account used in the deployment has access to the role and rolbinding that gives it the permissive PSP"
echo ""
echo "--Enter to continue"
read var

echo "--Clean up the deployment"

echo "kubectl delete deploy $(kubectl get deploy | awk '{print $1}')"
kubectl delete deploy $(kubectl get deploy | awk '{print $1}')

echo ""
echo "--Enter to continue"
read var

echo "--step-9 complete"
echo ""
echo "Congratulations! You have successfully completed the Pod Security Policy workshop"
