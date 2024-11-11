pipeline {
    agent any   
    environment {
        DOCKER_IMAGE = "parthitk/d2k:${BUILD_NUMBER}"
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub')
        UAT_SSH_KEY = credentials('UAT_SSH_KEY') 
    }
    parameters {
       choice(name: 'ENVIRONMENT', choices: ['UAT', 'Production'], description: 'Choose the environment to deploy to')
    }
    stages {
        stage('Clone Code') {
            steps {
                echo "scm checkout"
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "docker-hub") {
                        docker.image("${DOCKER_IMAGE}").push()
                    }
                }
            }
        }
        stage('Deploy to UAT') {
            steps {
                script {
                    echo "Deploying to UAT environment on EC2 instance..."
                    def ec2Ip = (params.ENVIRONMENT == 'UAT') ? env.UAT_EC2_IP : env.PROD_EC2_IP 
                    // Use `sshagent` to access the stored SSH key securely
                    sshagent(['UAT_SSH_KEY']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ubuntu@${ec2Ip} '
                                
                                docker run -d --name cont1 -p 1010:5000 ${DOCKER_IMAGE}
                            '
                        """
                    }
                }
            }
        }       
    }
}