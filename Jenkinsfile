pipeline {
    agent { label 'built-in-node' } // Change to the label of your built-in node
    stages {
        stage('Setup Namespace') {
            steps {
                script {
                    // Create the webapp namespace if it doesn't exist
                    sh 'kubectl create namespace webapp || echo "Namespace webapp already exists."'
                }
            }
        }
        stage('Checkout') {
            steps {
                // Checkout the repository
                git branch: 'main', url: 'https://github.com/zyadtarek11/kuberentes_three_tier.git'
            }
        }
        stage('Deploy Database') {
            steps {
                script {
                    // Apply the database PVC and secret
                    sh '''
                    kubectl apply -f db-secret.yaml -n webapp
                    kubectl apply -f db-data-pv.yaml -n webapp
                    kubectl apply -f db-data-pvc.yaml -n webapp
                    kubectl apply -f mysql-deployment.yaml -n webapp
                    kubectl apply -f mysql-service.yaml -n webapp
                    '''
                }
            }
        }
        stage('Deploy Proxy') {
            steps {
                script {
                    // Apply the proxy deployment and service
                    sh '''
                    kubectl apply -f proxy-deployment.yaml -n webapp
                    kubectl apply -f proxy-service.yaml -n webapp
                    '''
                }
            }
        }
        stage('Deploy Backend') {
            steps {
                script {
                    // Apply the backend deployment and service
                    sh '''
                    kubectl apply -f backend-deployment.yaml -n webapp
                    kubectl apply -f backend-service.yaml -n webapp
                    '''
                }
            }
        }
    }
}