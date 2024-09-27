pipeline {
    agent {
        kubernetes {
            label 'kubectl'
            yaml """
            apiVersion: v1
            kind: Pod
            metadata:
              labels:
                some-label: my-label
            spec:
              containers:
              - name: kubectl
                image: bitnami/kubectl:latest
                command:
                - cat
                tty: true
            """
        }
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout the repository
                git branch: 'main', url: 'https://github.com/zyadtarek11/kuberentes_three_tier.git'
            }
        }
        stage('Create Namespace') {
            steps {
                script {
                    // Create the 'webapp' namespace if it doesn't exist
                    sh '''
                    kubectl get namespace webapp || kubectl create namespace webapp
                    '''
                }
            }
        }
        stage('Set Namespace') {
            steps {
                script {
                    // Change context to the 'webapp' namespace
                    sh 'kubectl config set-context --current --namespace=webapp'
                }
            }
        }
        stage('Deploy Database') {
            steps {
                script {
                    // Apply the database PVC and secret
                    sh '''
                    kubectl apply -f db-secret.yaml
                    kubectl apply -f db-data-pv.yaml
                    kubectl apply -f db-data-pvc.yaml
                    kubectl apply -f mysql-deployment.yaml
                    kubectl apply -f mysql-service.yaml
                    '''
                }
            }
        }
        stage('Deploy Proxy') {
            steps {
                script {
                    // Apply the proxy deployment and service
                    sh '''
                    kubectl apply -f proxy-deployment.yaml
                    kubectl apply -f proxy-service.yaml
                    '''
                }
            }
        }
        stage('Deploy Backend') {
            steps {
                script {
                    // Apply the backend deployment and service
                    sh '''
                    kubectl apply -f backend-deployment.yaml
                    kubectl apply -f backend-service.yaml
                    '''
                }
            }
        }
    }
}