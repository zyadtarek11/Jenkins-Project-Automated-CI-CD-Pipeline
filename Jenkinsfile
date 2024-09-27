pipeline {
  agent {
        kubernetes {
            label 'my-agent'
            defaultContainer 'jnlp'
            yaml """
            apiVersion: v1
            kind: Pod
            metadata:
              name: jenkins-agent
            spec:
              serviceAccountName: jenkins-admin
              containers:
              - name: jnlp
                image: jenkins/inbound-agent
              - name: docker
                image: docker:20.10.7
                command:
                - cat
                tty: true
                volumeMounts:
                - name: docker-socket
                  mountPath: /var/run/docker.sock
              - name: kubectl
                image: kumargaurav522/jnlp-kubectl-slave:latest
                command:
                - cat
                tty: true
              - name: git
                image: bitnami/git:latest
                command:
                - cat
                tty: true
              volumes:
              - name: docker-socket
                hostPath:
                  path: /var/run/docker.sock
            """
        }
    }
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