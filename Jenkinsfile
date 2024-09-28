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
                    // Write kubeconfig content to a temporary file
                    writeFile file: 'kubeconfig', text: '''apiVersion: v1
clusters:
- cluster:
    certificate-authority: /home/zyad/.minikube/ca.crt
    extensions:
    - extension:
        last-update: Fri, 27 Sep 2024 15:59:30 EEST
        provider: minikube.sigs.k8s.io
        version: v1.34.0
      name: cluster_info
    server: https://192.168.49.2:8443
  name: minikube
contexts:
- context:
    cluster: minikube
    extensions:
    - extension:
        last-update: Fri, 27 Sep 2024 15:59:30 EEST
        provider: minikube.sigs.k8s.io
        version: v1.34.0
      name: context_info
    namespace: jenkins
    user: minikube
  name: minikube
current-context: minikube
kind: Config
preferences: {}
users:
- name: minikube
  user:
    client-certificate: /home/zyad/.minikube/profiles/minikube/client.crt
    client-key: /home/zyad/.minikube/profiles/minikube/client.key
                    '''

                    // Use this temporary kubeconfig file for kubectl commands
                    withEnv(["KUBECONFIG=kubeconfig"]) {
                        // Create namespace if it doesn't exist
                        sh "kubectl create namespace ${NAMESPACE} || echo 'Namespace ${NAMESPACE} already exists.'"
                    }
                }
            }
        }
        stage('Checkout Code') {
            steps {
                // Checkout the repository
                git branch: 'main', url: "${REPO_URL}"
            }
        }
        stage('Build and Push Backend Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        // Build and push the Docker image for backend
                        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                        sh 'docker build -t backend .'
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
                        // Build and push the Docker image for nginx (proxy)
                        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                        sh 'docker build -t proxy .'
                        sh "docker tag proxy ${DOCKER_REGISTRY}/proxy"
                        sh "docker push ${DOCKER_REGISTRY}/proxy"
                    }
                }
            }
        }
        stage('Deploy Database') {
            steps {
                script {
                    // Use the kubeconfig file to deploy the database resources
                    withEnv(["KUBECONFIG=kubeconfig"]) {
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
        stage('Deploy Backend') {
            steps {
                script {
                    // Use the kubeconfig file to deploy the backend resources
                    withEnv(["KUBECONFIG=kubeconfig"]) {
                        sh '''
                        kubectl apply -f backend-deployment.yaml -n ${NAMESPACE}
                        kubectl apply -f backend-service.yaml -n ${NAMESPACE}
                        '''
                    }
                }
            }
        }
        stage('Deploy Proxy') {
            steps {
                script {
                    // Use the kubeconfig file to deploy the proxy (nginx) resources
                    withEnv(["KUBECONFIG=kubeconfig"]) {
                        sh '''
                        kubectl apply -f proxy-deployment.yaml -n ${NAMESPACE}
                        kubectl apply -f proxy-service.yaml -n ${NAMESPACE}
                        '''
                    }
                }
            }
        }
    }
}