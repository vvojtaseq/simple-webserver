pipeline {
    agent any

    environment {
        IMAGE_NAME = "simple-webserver"
        BUILDER_IMAGE = "simple-webserver/builder:1.0"
//        RUNTIME_TAG = "${env.BUILD_ID}"
//        DOCKER_REGISTRY = "https://index.docker.io/v1/"
//        DOCKER_CREDENTIALS_ID = "docker-hub-credentials"
    }
    
    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/vvojtaseq/simple-webserver'
            }
        }

        stage('Build builder image') {
            steps {
                sh "docker build -t ${BUILDER_IMAGE} -f Dockerfile.build --target builder ."
                archiveArtifacts artifacts: 'webserver', fingerprint: true
            }
        }
    }
}