#!/usr/bin/env bash
echo "--kubectl get psp"
kubectl get psp
echo ""
echo "--Enter to continue"
read var
echo "--kubectl get psp | grep pks | awk '{print $1}'"
kubectl get psp | grep pks | awk '{print $1}'

echo ""
echo "--These are out-of-box PSP created by PKS in the Default namespace. We will delete these and create our own in this workshop."
echo "--Enter to continue."
read var

echo "--kubectl delete psp $(kubectl get psp | grep pks | awk '{print $1}')"
kubectl delete psp $(kubectl get psp | grep pks | awk '{print $1}')

echo ""
echo "--Enter to continue"
read var
echo "--kubectl get psp | grep pks"
kubectl get psp | grep pks
echo ""
echo "--Enter to continue"
read var

echo "--step-3 complete"