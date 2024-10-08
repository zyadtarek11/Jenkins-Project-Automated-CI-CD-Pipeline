eval $(minikube docker-env) #Switch Minikube to Docker Environment 
docker build -t custom-jenkins:latest -f Dockerfile.jenkins .
kubectl create namespace jenkins 
kubectl apply -f jenkins-service.yaml -n jenkins
kubectl apply -f jenkins-deployment.yaml -n jenkins
kubectl apply -f jenkins-service-account.yaml -n jenkins
kubectl apply -f jenkins-cluster-role.yaml -n jenkins
kubectl apply -f jenkins-cluster-role-binding.yaml -n jenkins
kubectl apply -f jenkins-pv.yaml -n jenkins