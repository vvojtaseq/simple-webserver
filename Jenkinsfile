pipeline {
    agent any

    environment {
        IMAGE_NAME = "simple-webserver"
        BUILDER_IMAGE = "simple-webserver/builder:1.0"
        RUNTIME_TAG = "${env.BUILD_ID}"
        DOCKER_REGISTRY = "https://index.docker.io/v1/"
        DOCKER_CREDENTIALS_ID = "docker-hub-credentials"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/vvojtaseq/simple-webserver.git'
            }
        }

        stage('Build builder image') {
            steps {
                script {
                    docker.build(BUILDER_IMAGE, "-f Dockerfile.build --target builder  .")
                }
                archiveArtifacts artifacts: 'webserver', fingerprint: true    
            }
        }
/*
        stage('Build runtime image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${RUNTIME_TAG} -f Dockerfile.build ."
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    docker.image(BUILDER_IMAGE).inside {
                        sh 'go test ./... -v | tee test-output.txt || true'
                    }
                    archiveArtifacts artifacts: 'test-output.txt', fingerprint: true
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh "docker compose -f docker-compose.deploy.yml up -d"
                    sleep 3
                    sh "curl --fail -sS http://localhost:8082/ping"
                }
            }
        }

        stage('Publish') {
            when {
                expression { env.DOCKER_CREDENTIALS_ID != null && env.DOCKER_CREDENTIALS_ID != '' }
            }
            steps {
                script {
                    docker.withRegistry("${DOCKER_REGISTRY}", "${DOCKER_CREDENTIALS_ID}") {
                        docker.image("${IMAGE_NAME}:${RUNTIME_TAG}").push('latest')
                        docker.image("${IMAGE_NAME}:${RUNTIME_TAG}").push("${RUNTIME_TAG}")
                    }
                }
            }
        }
    }
}
*/