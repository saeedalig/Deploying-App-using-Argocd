pipeline {
    agent any

    environment {

        DOCKERHUB_USERNAME = "asa96"
        APP_NAME = "gitops_argocd_app"
        IMAGE_TAG = "${BUILD_NUMBER}"
        IMAGE_NAME = "${DOCKERHUB_USERNAME}" + "/" + "${APP_NAME}"
        REGISTRY_CREDS = "dockerHub"

    }
    
    stages {
        
        stage('Cleanup Workspace') {
            steps {
                script {
                    cleanWs()
                }
            }
        }
        
        stage('Checkout SCM') {
            steps {
                script {
                    git credentialsId: "Github",
                        url: "https://github.com/saeedalig/gitops-argocd.git",
                        branch: "main"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker_image = docker.build "${IMAGE_NAME}"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', REGISTRY_CREDS) {
                        docker_image.push("$BUILD_NUMBER")
                        docker_image.push("latest")
                    }
                }
            }
        }

        stage('Remove Docker Image') {
            steps {
                script {
                sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
                sh "docker rmi ${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Updating k8s deployment file') {
            steps {
                script {
                sh """
                    cat deployment.yaml
                    sed -i "s/${APP_NAME}.*/${APP_NAME}:${IMAGE_TAG}/g" deployment.yaml
                    cat deployment.yaml
                """
                }
            }
        }

        stage('Push Updated deployment file to GitHub') {
            steps {
                script {
                sh """
                    git config --global user.name "edwin"
                    git config --global user.email "edswin@gmail.com"
                    git add deployment.yaml
                    git commit -m "push updated deployment.yaml" 
                """
                withCredentials([gitUsernamePassword(credentialsId: 'Github', gitToolName: 'Default')]) {
                    sh "git push https://github.com/saeedalig/gitops-argocd.git"     
                    }
                }
            }
        }
    }
}

