#!/usr/bin/env bash
echo "--This lab is more intense, so take your time to understand what is happening"
echo "--Now we will explore how the namespace level RBAC is applied."
echo "--Here we will create a RoleBinding instead of a ClusterRoleBinding."
echo "--However, the role will be a ClusterRole."
echo "--So a RoleBinding which is at a namespace level will refer to the ClusterRole which is defined at a cluster level."
echo ""
echo "--First let us create a separate namespace."
echo "--Enter to continue"
read var
echo "kubectl  create ns psp"
kubectl  create ns psp

echo ""
echo "kubectl  get ns"
kubectl  get ns
echo "--Enter to continue"
read var

echo "--Now, let us create a role binding in psp namespace."
echo "--Enter to continue"
read var

echo "kubectl apply -f rb-permissive-ns-psp.yml"
kubectl apply -f rb-permissive-ns-psp.yml

echo "--Enter to continue"
read var
echo "kubectl get rolebinding -n psp"
kubectl get rolebinding -n psp

echo "--Enter to continue"
read var
echo "--The role binding here is only given to replication controller's service account because that's all we need at this point."

echo "--Before we proceed let us delete old deployments if any."
echo ""
echo "kubectl delete deploy $(kubectl get deploy | awk '{print $1}')"
kubectl delete deploy $(kubectl get deploy | awk '{print $1}')

echo "--Enter to continue"
read var
echo "--Now, let us try to create the privileged nginx deployment in the default namespace."
echo "--Enter to continue"
read var

echo "kubectl apply -f nginx-deployment-hostnw.yml"
kubectl apply -f nginx-deployment-hostnw.yml

echo "--Enter to continue"
read var
echo "kubectl get rs,po"
kubectl get rs,po
echo "--Enter to continue"
read var

echo "--Let us see if why the pod is not there"
echo "--Enter to continue"
read var
echo "kubectl describe rs $(kubectl get rs | grep nginx-deployment-hostnw | awk '{print $1}')"

kubectl describe rs $(kubectl get rs | grep nginx-deployment-hostnw | awk '{print $1}')
echo "--Enter to continue"
read var

echo "--It failed because the the permissive role binding is only available in the psp namespace."
echo "--Delete the failed deployment."
echo "--Enter to continue"
read var

echo "kubectl delete deploy $(kubectl get deploy | awk '{print $1}')"
kubectl delete deploy $(kubectl get deploy | awk '{print $1}')

echo "--Enter to continue"
read var
echo "--Now, let us try to create the privileged nginx deployment in the psp namespace."
echo "--Enter to continue"
read var
echo "kubectl apply -f nginx-deployment-hostnw.yml -n psp"
kubectl apply -f nginx-deployment-hostnw.yml -n psp

echo ""
echo "--Enter to continue"
read var
echo "kubectl get rs,po -n psp"
kubectl get rs,po -n psp

echo "--Do you see the Pod now? YES! You should see the pod if you did everything right."
echo "--This is a pod with privileged access to Host"
echo "--We are able to create it because the namespace has the required rolebinding that gives permissive PSP to the service account used by replicaset controller."
echo ""
echo "--Enter to continue"
read var

echo "kubectl delete deploy $(kubectl get deploy -n psp | awk '{print $1}') -n psp"
kubectl delete deploy $(kubectl get deploy -n psp | awk '{print $1}') -n psp

echo ""
echo "--Enter to continue"
read var
echo "kubectl get deploy,rs,po -n psp"
kubectl get deploy,rs,po -n psp
echo ""
echo "--Enter to continue"
read var

echo "kubectl delete ns psp"
kubectl delete ns psp

echo ""
echo "--Enter to continue"
read var

echo "--step-8 complete"