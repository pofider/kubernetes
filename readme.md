
# Kubernetes infrastructure

## Application deployment

Applications deployed to the kubernetes cluster:
- [janblaha](https://github.com/pofider/janblaha)
- [playground](https://github.com/jsreport/playground)
- [website](https://github.com/jsreport/website)
- [forum](https://github.com/jsreport/forum)
- [jo-health-check](https://github.com/pofider/johealthcheck)
- mongodb standard image

All applications have the CI deployment set up. 

### How to deploy new version
Just create a new release tag. This triggers travis to build a new docker image and update the kubernetes staging application which is afterwards available on dns "playground|forum|janblaha|website".jsreport.cloud. 

When the staging application looks ok it is time to deploy to production. This is done through merging PR automatically created during the previous process. 

Open kubernetes repo in github. You should see the new branch created with name "update-playground:xx". The github offers button create pull request and merge it. This will trigger travis autobuild and deploy the application also to the production.

### What every application needs to provide

Travis is enabled.

The `travis.yaml` contains deploy section and proper environment variables with github and dockerhub keys.

The deploy script  `deploy.sh` with service and docker image specification is in the repository.

Dockerhub repository is set up.

The [kubernetes/config/staging](https://github.com/pofider/kubernetes/tree/master/config/staging) and [kubernetes/config/prod](https://github.com/pofider/kubernetes/tree/master/config/staging) includes particular service definition.

## Azure cloud

The kubernetes cluster runs in azure. You can login to the cluster using azure cli:
```
az login
az aks install-cli
az aks get-credentials --resource-group jsreport --name jsreport
kubectl get pods
```


## Kuberenetes Cheat sheet

**restart pod**
kubectl get pod playground-695c6f874f-5tnsh -o yaml | kubectl replace --force -f -

**reboot ingress**
kubectl exec ingres-pod /sbin/killall5 -n kube-system

**get ingress nginx config**
kubectl exec excited-squirrel-nginx-ingress-controller-6594c58f4b-rk9gk cat /etc/nginx/nginx.conf > nginx.conf -n kube-system

**create ssl certificate**
kubectl create secret tls janblaha-tls-secret --key janblaha.net.key --cert janblaha.net.cert

**install nginx ingress**
helm init
helm install stable/nginx-ingress --namespace kube-system --set rbac.create=false

**add secrent env variable to travis**
travis encrypt DOCKER_USERNAME="pofider" --add

**copy file from kubernetes pod**
kubectl cp default/temp-7c9d7f467c-l684n:/disk/forum.tar.gz forum.tar.gz
mongodump
tar -zcvf forum.tar.gz forum

**edit deployment**
kubectl edit deployment/deployment-name

**kubernetes node logs**
kubectl describe nodes