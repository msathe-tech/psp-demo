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
There is one way to validate that the PSP is working in your cluster.
Simply try creating a deployment and see if Pods creation is successful.

`kubectl apply -f nginx-deployment.yml`

`kubectl get po,rs`
Here you will see only Replica Set.

`kubectl describe rs $(kubectl get rs | grep nginx-deployment | awk '{print $1}')`

Delete the deployment once verified - 

`kubectl delete deploy nginx-deployment`

### Pod creation by admin user 

Now we will try to create a Pod directly using the admin user. 

`kubectl run nginx --image=nginx --restart=Never`

`kubectl get po`

As you can see the Pod is created successfully when we directly create it.


### TBD - Pod creation by non-admin user


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

## Step 3 - cleanup 
First we clean up the PSPs setup by PKS install.
List all PSPs setup in the cluster, find the PSPs starting with 'psp' and delete them. 

`kubectl get psp`

`kubectl get psp | grep psp | awk '{print $1}'`

`kubectl delete psp $(kubectl get psp | grep psp | awk '{print $1}')`

## Step 4 - create your own PSP resources
Create two PSPs, one restrictive and one permissive.
The restrictive policy doesn't allow privileged operations and permissive one does. 
We will make use of both in the demo.

`kubectl apply -f psp-restrictive.yml -f psp-permissive.yml `

`kubectl get psp -l type=madhav-psp`

Now that the pod security policies are created, will we be able to create a deployment successfully? 
NO. Try it out. 

`kubectl apply -f nginx-deployment.yml`

`kubectl get rs,po`

`kubectl describe rs $(kubectl get rs | grep nginx-deployment | awk '{print $1}')`

## Step 5 - create cluster roles and give them 'use' access to PSP
Now we will create cluster roles, one for each PSP. 
A cluster role is applied at a cluster level. 
So any controller that has this role will get resources the role has access to across all namespaces of the cluster.

Pay attention to the 'use' verb, this is the access controller needs in order to use the PSP. 

`kubectl apply -f cr-restrictive.yml -f cr-permissive.yml`

## Step 6 - create cluster role bindings and try deployment 
Cluster role binding associates service account(s) to a cluster role. 

First, we will create a role binding that will apply to all service accounts in kube-system namespace.
These service accounts are used by the controllers (such as replication controller) to create pods. 

`kubectl apply -f crb-restrictive.yml`

Now we will try to create the nginx deployment and see if the pod creation is successful this time. 

`kubectl apply -f nginx-deployment.yml`

`kubectl get rs,po`

Do you see the Pod? YES! You should see the Pod now if you did everything right. 

## Step 7 - create a deployment with privileged access 
Now we will try to create a deployment with privileged access. 
In this case we are trying to get access to Host's network. 

`kubectl apply -f nginx-deployment-hostnw.yml`

Verify if the new pod got created.
`kubectl get rs,po`

Check why the pod creation failed for new deployment. 

`kubectl describe rs $(kubectl get rs | grep nginx-deployment-hostnw | awk '{print $1}')`

This is expected. You shouldn't require to use host's network for your applications.

## Step 8 - namespace level RBAC
Now we will explore how the namespace level RBAC is applied. 
Here we will RoleBinding instead of a ClusterRoleBinding. 
However, the role will be ClusterRole. 
So a RoleBinding which is at a namespace level will refer to the ClusterRole which is defined at a cluster level.

First let us create a separate namespace.

`kubectl  create ns psp`

`kubectl  get ns`

Now, let us create a role binding in psp namespace. 

`kubectl apply -f rb-permissive-ns-psp.yml`

`kubectl get rolebinding -n psp`

The role binding here is only given to replication controller's service account because that's all we need at this point.

Before we proceed let us delete old deployments. 

`kubectl delete deploy $(kubectl get deploy | awk '{print $1}')`

Now, let let us try to create the privileged nginx deployment in the default namespace. 

`kubectl apply -f nginx-deployment-hostnw.yml`

`kubectl get rs,po`

`kubectl describe rs $(kubectl get rs | grep nginx-deployment-hostnw | awk '{print $1}')`

It will failed because the the permissive role binding is only available in the psp namespace. 

`kubectl delete deploy $(kubectl get deploy | awk '{print $1}')`

Now, let us try to create the privileged nginx deployment in the psp namespace. 

`kubectl apply -f nginx-deployment-hostnw.yml -n psp`

`kubectl get rs,po -n psp`

Clean up.

`kubectl delete deploy $(kubectl get deploy -n psp | awk '{print $1}') -n psp`

## Step 9 - PSP for service account specific deployments 
In Step 8 we saw how the 'nginx-deployment-hostnw' deployment failed in the default namespace. 
We want to avoid giving blanket permission to start privileged containers in the default namespace.
However, we may have one particular app that may require such a privilege.
In that case you can create a separate service account and specify that in the app deployment. 
This service account can be given the required role using the namespace. 

Create a service account. 

`kubectl create sa specialsa`

Now, create the role binding for this service account. 

`kubectl apply -f rb-permissive-sa.yml`

`kubectl get rolebinding`

Time to test -

`kubectl apply -f nginx-deployment-hostnw-sa.yml`

`kubectl get rs,po`

Clean up -

`kubectl delete deploy $(kubectl get deploy | awk '{print $1}')`
