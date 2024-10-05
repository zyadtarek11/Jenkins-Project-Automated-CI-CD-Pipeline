#!/bin/bash

# Switch Minikube to Docker environment
eval $(minikube docker-env)

# Delete Kubernetes resources in the 'jenkins' namespace
kubectl delete -f jenkins-service.yaml -n jenkins
kubectl delete -f jenkins-deployment.yaml -n jenkins
kubectl delete -f jenkins-service-account.yaml -n jenkins
kubectl delete -f jenkins-cluster-role.yaml -n jenkins
kubectl delete -f jenkins-cluster-role-binding.yaml -n jenkins
kubectl delete -f jenkins-pv.yaml -n jenkins

# Delete the Jenkins namespace
kubectl delete namespace jenkins

# Remove Docker image
docker rmi custom-jenkins:latest

echo "Jenkins setup destroyed and Docker image removed!"
