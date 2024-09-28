pipeline {
    agent any
    environment {
        NAMESPACE = 'webapp'
        REPO_URL = 'https://github.com/zyadtarek11/kuberentes_three_tier.git'
        DOCKER_REGISTRY = 'zyadtarek'
    }
    stages {
        stage('Setup Namespace') {
            steps {
                script {
                    // Use kubeconfig credentials to authenticate with Kubernetes
                    withCredentials([file(credentialsId: 'k8sconfig', variable: 'KUBECONFIG')]) {
                        // Create the webapp namespace if it doesn't exist
                        sh "kubectl create namespace ${NAMESPACE} || echo 'Namespace ${NAMESPACE} already exists.'"
                    }
                }
            }
        }
        stage('Checkout') {
            steps {
                // Checkout the repository from the specified URL
                git branch: 'main', url: "${REPO_URL}"
            }
        }
        stage('Build and Push Backend Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        // Login to Docker Registry
                        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"

                        // Build and push the backend Docker image from the root directory
                        sh 'docker build -t backend -f Dockerfile.backend .'
                        sh "docker tag backend ${DOCKER_REGISTRY}/backend"
                        sh "docker push ${DOCKER_REGISTRY}/backend"
                    }
                }
            }
        }
        stage('Build and Push Nginx Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        // Login to Docker Registry (if necessary, skip if already logged in)
                        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"

                        // Build and push the Nginx Docker image from the root directory
                        sh 'docker build -t nginx -f Dockerfile.nginx .'
                        sh "docker tag nginx ${DOCKER_REGISTRY}/nginx"
                        sh "docker push ${DOCKER_REGISTRY}/nginx"
                    }
                }
            }
        }
        stage('Deploy Database') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'k8sconfig', variable: 'KUBECONFIG')]) {
                        // Apply the database PVC and secret
                        sh '''
                        kubectl apply -f db-secret.yaml -n ${NAMESPACE}
                        kubectl apply -f db-data-pv.yaml -n ${NAMESPACE}
                        kubectl apply -f db-data-pvc.yaml -n ${NAMESPACE}
                        kubectl apply -f mysql-deployment.yaml -n ${NAMESPACE}
                        kubectl apply -f mysql-service.yaml -n ${NAMESPACE}
                        '''
                    }
                }
            }
        }
        stage('Deploy Proxy') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'k8sconfig', variable: 'KUBECONFIG')]) {
                        // Apply the proxy deployment and service
                        sh '''
                        kubectl apply -f proxy-deployment.yaml -n ${NAMESPACE}
                        kubectl apply -f proxy-service.yaml -n ${NAMESPACE}
                        '''
                    }
                }
            }
        }
        stage('Deploy Backend') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'k8sconfig', variable: 'KUBECONFIG')]) {
                        // Apply the backend deployment and service
                        sh '''
                        kubectl apply -f backend-deployment.yaml -n ${NAMESPACE}
                        kubectl apply -f backend-service.yaml -n ${NAMESPACE}
                        '''
                    }
                }
            }
        }
    }
}