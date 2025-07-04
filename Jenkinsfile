pipeline {
    agent any

    environment {
        IMAGE_NAME = "hello-nginx-node"
        CONTAINER_NAME = "hello-nginx-container"
        DOCKER_HUB_IMAGE = "devopsabhishekh/hello-nginx-node"
        HOST_HTTP_PORT = "13011"
        HOST_HTTPS_PORT = "13012"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/ItSpecialistDevOps/MyNewProject.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $IMAGE_NAME ."
            }
        }

        stage('Run Container') {
            steps {
                sh "docker rm -f $CONTAINER_NAME || true"
                sh "docker run -d -p $HOST_HTTP_PORT:80 -p $HOST_HTTPS_PORT:443 --name $CONTAINER_NAME $IMAGE_NAME"
            }
        }

        stage('Tag & Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker tag $IMAGE_NAME $DOCKER_HUB_IMAGE
                        docker push $DOCKER_HUB_IMAGE
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Build, run, and push to Docker Hub succeeded!'
        }
        failure {
            echo '❌ Pipeline failed.'
        }
    }
}
