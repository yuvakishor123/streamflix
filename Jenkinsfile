pipeline {
    agent any

    environment {
        WORK_DIR        = "${env.WORKSPACE}"
        IMAGE_NAME      = "netflix-clone"
        IMAGE_TAG       = "latest"
        CONTAINER_NAME  = "netflix-container"
        HOST_PORT       = "3000"
        DOCKERHUB_REPO  = "yuvakishor/yuva"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/yuvakishor123/netflix-clone-react-typescript.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker rmi -f ${IMAGE_NAME}:${IMAGE_TAG} || true
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -f ${WORK_DIR}/Dockerfile ${WORK_DIR}
                '''
            }
        }

        stage('Run Docker Container (Local Test)') {
            steps {
                sh '''
                    docker rm -f ${CONTAINER_NAME} || true
                    docker run -d --name ${CONTAINER_NAME} -p ${HOST_PORT}:80 ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }
         
        stage('Docker Hub Login & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKERHUB_REPO}:${IMAGE_TAG}
                        docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}
                        docker logout
                    '''
                }
            }
        }
    }
}
    
