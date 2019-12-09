#!/usr/bin/env bash
echo "--Create two PSPs, one restrictive and one permissive."
echo "--The restrictive policy doesn't allow privileged operations and permissive one does."
echo "--We will make use of both in the demo."
echo ""
echo "--kubectl apply -f psp-restrictive.yml -f psp-permissive.yml"
kubectl apply -f psp-restrictive.yml -f psp-permissive.yml
echo ""
echo "--Enter to continue"
read var
echo "--kubectl get psp -l type=madhav-psp"
kubectl get psp -l type=madhav-psp
echo ""
echo "--Enter to continue"
read var
echo "--Now that the pod security policies are created, will we be able to create a deployment successfully?"
echo "--NO. Try it out. Enter to coninue"
read var

echo "--kubectl apply -f nginx-deployment.yml"
kubectl apply -f nginx-deployment.yml
echo ""
echo "--Enter to continue"
read var
echo "--kubectl get rs,po"
kubectl get rs,po

echo ""
echo "--Check why the deployment failed to create the pod. Enter to continue"
read var
echo "--kubectl describe rs $(kubectl get rs | grep nginx-deployment | awk '{print $1}')"
kubectl describe rs $(kubectl get rs | grep nginx-deployment | awk '{print $1}')

echo ""

echo "--Enter to continue"
read var

echo "--step-4 complete"