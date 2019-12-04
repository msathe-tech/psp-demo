#!/usr/bin/env bash
echo "--Now we will create cluster roles, one for each PSP."
echo "--A cluster role is available at a cluster level."

echo "--Pay attention to the 'use' verb, this is the access controller needs in order to use the PSP."

echo "--Enter to continue"
read var

echo "--kubectl apply -f cr-restrictive.yml -f cr-permissive.yml"
kubectl apply -f cr-restrictive.yml -f cr-permissive.yml
echo "--Enter to continue"
read var

echo "--kubectl get clusterrole -l type=madhav-psp"
kubectl get clusterrole -l type=madhav-psp

echo "--You are still going to need bindings to use these roles. Enter to continue"
read var

echo "--step-5 complete"