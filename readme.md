# jsreport infrastructure

## Install on kubernetes

create AKS service
no rbac
no http routing
custom service principal 9173b07c-f531-45eb-94f0-713a5cc56c9a Dw8CDwA

helm init
helm install stable/nginx-ingress --namespace kube-system --set rbac.create=false

kubectl apply -Rf .\config\

## Cheat sheet

**restart pod**
kubectl get pod playground-695c6f874f-5tnsh -o yaml | kubectl replace --force -f -

**reboot ingress**
kubectl exec ingres-pod /sbin/killall5 -n kube-system

**get ingress nginx config**
kubectl exec ingress-pod cat /etc/nginx/nginx.conf > nginx.conf -n kube-system

**create ssl certificate**
kubectl create secret tls janblaha-tls-secret --key janblaha.net.key --cert janblaha.net.cert

**install nginx ingress**
helm init
helm install stable/nginx-ingress --namespace kube-system --set rbac.create=false

**add secrent env variable to travis**
travis encrypt DOCKER_USERNAME="pofider" --add

**copy file from kubernetes pod**
kubectl cp default/mongodb-6dc7b695bd-6b5z8:/dump.tar.gz dump.tar.gz
mongodump
tar -zcvf dump.tar.gz dump

**edit deployment**
kubectl edit deployment/deployment-name