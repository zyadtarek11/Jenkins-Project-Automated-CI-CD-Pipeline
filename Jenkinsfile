pipeline {
    agent any
    environment {
        NAMESPACE = 'webapp'
        REPO_URL = 'https://github.com/zyadtarek11/kuberentes_three_tier.git'
        DOCKER_REGISTRY = 'zyadtarek'  // Assuming this is your Docker Hub username
        IMAGE_NAME_BACKEND = "${DOCKER_REGISTRY}/backend"
        IMAGE_NAME_NGINX = "${DOCKER_REGISTRY}/nginx"
        registryCredential = 'dockerhub-credentials' // Your Jenkins credentials ID
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
                    // Build and push the backend Docker image
                    sh """
                    docker build -t ${IMAGE_NAME_BACKEND}:${env.BUILD_NUMBER} -f Dockerfile .
                    echo ${env.DOCKER_PASS} | docker login -u ${env.DOCKER_USER} --password-stdin
                    docker push ${IMAGE_NAME_BACKEND}:${env.BUILD_NUMBER}
                    """
                }
            }
        }
        stage('Build and Push Nginx Image') {
            steps {
                script {
                    // Build and push the Nginx Docker image
                    sh """
                    docker build -t ${IMAGE_NAME_NGINX}:${env.BUILD_NUMBER} -f Dockerfile.nginx .
                    echo ${env.DOCKER_PASS} | docker login -u ${env.DOCKER_USER} --password-stdin
                    docker push ${IMAGE_NAME_NGINX}:${env.BUILD_NUMBER}
                    """
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
