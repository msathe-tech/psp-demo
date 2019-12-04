#Pod Security Policies demo on PKS

## Step 1 - setup PKS
Refer to PKS documentation.

Create a PKS plan with following options enabled
1. Admission Plugins > PodSecurityPolicy
2. Allow Privileged (this is not related to PSP but will be useful for the demo)

In this demo we will refer to the plan as 'small-psp'.
Assumption is that 'small-psp' is available.
Create a cluster with 'small-psp' plan.

## Step 2 - validate the setup 
`./step-2.sh`

### Pod creation by admin user 

Now we will try to create a Pod directly using the admin user. 

`kubectl run nginx --image=nginx --restart=Never`

`kubectl get po`

As you can see the Pod is created successfully when we directly create it.

### Why is this?
This is because how, rather who is creating the pod. In the second case the Pod was created by the end user directly.
In earlier case the Pod is not directly created by the end user. It is created by the Replication Contoller that is associated with the given Deployment.
The Replication Controller is a typical K8s controller that uses a service account to interact with API server.
Unless the service account used by the contoller has the `use` permission on the Pod Security Policy it won't be allowed to create the Pod.

Run following command to see service accounts used by different controllers. 

`kubectl get serviceaccount -n kube-system | egrep -o '[A-Za-z0-9-]+-controller`

As you can see there are different service accounts dedicated to different controllers. 
Using service accounts for controllers is a global setting enabled on kube-controller-manager. 
This allows each contoller to use different policies via their assocation with the service account of each controller.

### What we will learn now?
In the following sections we will walk through the process of setting up and using PSPs.

## Step 3 - cleanup PKS created PSPs
`./step-3.sh`

## Step 4 - create your own PSP resources
`./step-4.sh`

## Step 5 - create cluster roles and give them 'use' access to PSP
`./step-5.sh`

## Step 6 - create cluster role bindings and try deployment 
`./step-6.sh`

## Step 7 - create a deployment with privileged access 
`./step-7.sh`

## Step 8 - namespace level RBAC
`./step-8.sh`

## Step 9 - PSP for service account specific deployments 
`./step-9.sh`
