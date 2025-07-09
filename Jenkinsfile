pipeline {
    agent any

    environment {
        IMAGE_NAME = "hello-nginx-node"
        CONTAINER_NAME = "hello-nginx-container"
        DOCKER_HUB_IMAGE = "devopsabhishekh/hello-nginx-node"
        HOST_HTTP_PORT = "13011"
        HOST_HTTPS_PORT = "13012"
        SONAR_PROJECT_KEY = "MyNewProject"
    }

    tools {
        nodejs 'Node16'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/ItSpecialistDevOps/MyNewProject.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonarqube-token', variable: 'SONAR_TOKEN')]) {
                    withSonarQubeEnv('MySonarServer') {
                        sh '''
                            npm install
                            sonar-scanner \
                              -Dsonar.projectKey=$SONAR_PROJECT_KEY \
                              -Dsonar.sources=. \
                              -Dsonar.host.url=$SONAR_HOST_URL \
                              -Dsonar.login=$SONAR_TOKEN
                        '''
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $IMAGE_NAME ."
            }
        }

        stage('Scan Image with Trivy') {
            steps {
                script {
                    sh '''
                        if ! command -v trivy &> /dev/null; then
                            echo "Installing Trivy..."
                            curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
                        fi

                        echo "Downloading Trivy HTML template..."
                        mkdir -p /tmp/trivy-template
                        curl -o /tmp/trivy-template/html.tpl https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/html.tpl

                        echo "Running Trivy scan..."
                        trivy image --format template --template @/tmp/trivy-template/html.tpl -o trivy-report.html $IMAGE_NAME
                    '''
                }
            }
        }

        stage('Archive Trivy Report') {
            steps {
                archiveArtifacts artifacts: 'trivy-report.html', fingerprint: true
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
            echo '✅ All stages completed: SonarQube, Trivy, Docker build & push!'
        }
        failure {
            echo '❌ Pipeline failed.'
        }
    }
}
