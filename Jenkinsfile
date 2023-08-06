pipeline {
    agent any
    
    stages {
        stage('checkout') {
            steps {
                script {
                    git credentialsId: "Github",
                        url: "https://github.com/saeedalig/gitops-argocd.git",
                        branch: "main"
                }
            }
        }
    }
}
