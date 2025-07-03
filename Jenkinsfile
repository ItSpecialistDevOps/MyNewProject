pipeline {
    agent any

    environment {
        IMAGE_NAME = "hello-nginx-node"
        CONTAINER_NAME = "hello-nginx-container"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/ItSpecialistDevOps/MyNewProject.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t $IMAGE_NAME ."
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    // Stop any previous container with the same name
                    sh "docker rm -f $CONTAINER_NAME || true"
                    // Run the container
                    sh "docker run -d -p 13001:80 -p 13002:443 --name $CONTAINER_NAME $IMAGE_NAME"
                }
            }
        }
    }

    post {
        success {
            echo 'Build and deploy succeeded!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}
