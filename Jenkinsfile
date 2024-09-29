pipeline {
    agent any
    environment {
        NAMESPACE = 'webapp'
        REPO_URL = 'https://github.com/zyadtarek11/kuberentes_three_tier.git'
        DOCKER_REGISTRY = 'zyadtarek'  // Your Docker Hub username
        registryCredential = 'dockerhub-credentials' // Your Jenkins credentials ID for Docker Hub
    }
    stages {
        stage('Setup Namespace') {
            steps {
                script {
                    // Create the webapp namespace if it doesn't exist
                    sh "kubectl create namespace ${NAMESPACE} || echo 'Namespace ${NAMESPACE} already exists.'"
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
                    // Build the backend Docker image with the Jenkins build number as the tag
                    sh """
                    docker build -t ${DOCKER_REGISTRY}/backend:${env.BUILD_NUMBER} -f Dockerfile .
                    """
                    // Push the backend image after building it
                    withDockerRegistry([ credentialsId: "dockerhub-credentials", url: "" ]) {
                        sh "docker push ${DOCKER_REGISTRY}/backend:${env.BUILD_NUMBER}"
                    }
                }
            }
        }
        stage('Build and Push Nginx Image') {
            steps {
                script {
                    // Build the Nginx Docker image with the Jenkins build number as the tag
                    sh """
                    docker build -t ${DOCKER_REGISTRY}/nginx:${env.BUILD_NUMBER} -f Dockerfile.nginx .
                    """
                    // Push the Nginx image after building it
                    withDockerRegistry([ credentialsId: "dockerhub-credentials", url: "" ]) {
                        sh "docker push ${DOCKER_REGISTRY}/nginx:${env.BUILD_NUMBER}"
                    }
                }
            }
        }
        stage('Deploy Database') {
            steps {
                script {
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
        stage('Deploy Proxy') {
            steps {
                script {
                    // Apply the proxy deployment and service
                    sh '''
                    kubectl apply -f proxy-deployment.yaml -n ${NAMESPACE}
                    kubectl apply -f proxy-service.yaml -n ${NAMESPACE}
                    '''
                }
            }
        }
        stage('Deploy Backend') {
            steps {
                script {
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