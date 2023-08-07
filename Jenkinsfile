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
    }
}
