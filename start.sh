kubectl apply -f jenkins-service.yaml
kubectl apply -f jenkins-deployment.yaml
kubectl create serviceaccount jenkins-service-account -n jenkins
kubectl apply -f jenkins-cluster-role.yaml
kubectl apply -f jenkins-cluster-role-binding.yaml
kubectl apply -f jenkins-pv.yaml