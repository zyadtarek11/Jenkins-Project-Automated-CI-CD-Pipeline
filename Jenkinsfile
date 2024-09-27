pipeline {
    agent any
    environment {
        NAMESPACE = 'webapp'
        REPO_URL = 'https://github.com/zyadtarek11/kuberentes_three_tier.git'
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
                // Checkout the repository
                git branch: 'main', url: "${REPO_URL}"
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