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
    environment {
        NAMESPACE = 'webapp'
        REPO_URL = 'https://github.com/zyadtarek11/kuberentes_three_tier.git'
        DOCKER_REGISTRY = 'zyadtarek'
        registryCredential = 'dockerhub-credentials' // Your Jenkins credentials ID
        backendImage = ''
        nginxImage = ''
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
                    docker.withRegistry('', registryCredential) {
                        backendImage = docker.build("${DOCKER_REGISTRY}/backend:${env.BUILD_NUMBER}", "-f Dockerfile .")
                        backendImage.push()
                    }
                }
            }
        }
        stage('Build and Push Nginx Image') {
            steps {
                script {
                    // Build and push the Nginx Docker image
                    docker.withRegistry('', registryCredential) {
                        nginxImage = docker.build("${DOCKER_REGISTRY}/nginx:${env.BUILD_NUMBER}", "-f Dockerfile.nginx .")
                        nginxImage.push()
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