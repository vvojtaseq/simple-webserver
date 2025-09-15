pipeline {
    agent any

    environment {
        IMAGE_NAME = "simple-webserver"
        BUILDER_IMAGE = "simple-webserver/builder:1.0"
        RUNTIME_TAG = "${env.BUILD_ID}"
//        DOCKER_REGISTRY = "https://index.docker.io/v1/"
//        DOCKER_CREDENTIALS_ID = "docker-hub-credentials"
    }
    
    stages {
        stage('Build builder image') {
            steps {
                sh "docker build -t ${BUILDER_IMAGE} -f Dockerfile.build --target builder ."
                archiveArtifacts artifacts: 'webserver', fingerprint: true
            }
        }

        stage('Build runtime image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${RUNTIME_TAG} -f Dockerfile.build ."
            }
        }

        stage('Test') {
            steps {
                sh """
                    docker run --rm -v ${WORKSPACE}:/app -w /app ${BUILDER_IMAGE} \
                    sh -c 'go test ./... -v | tee test-output.txt || true'
                """
                archiveArtifacts artifacts: 'test-output.txt', fingerprint: true
            }
        }
    }
}





