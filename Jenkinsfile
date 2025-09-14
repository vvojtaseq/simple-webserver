pipeline {
  agent any

  environment {
    IMAGE_NAME = "simple-webserver"
    BUILDER_IMAGE = "simple-webserver/builder:1.0"
    RUNTIME_TAG = "${env.BUILD_ID}"
    DOCKER_REGISTRY = "https://index.docker.io/v1/"
    DOCKER_CREDENTIALS_ID = "docker-hub-credentials"

  stages {

    stage('Prepare builder image') {
      steps {
        script {
          echo "Building builder image ${BUILDER_IMAGE}"
          docker.build(BUILDER_IMAGE, "-f Dockerfile.build .")
          sh "docker images | grep ${IMAGE_NAME} || true"
        }
      }
    }

    stage('Build') {
      steps {
        script {
          echo "Running build inside ${BUILDER_IMAGE}"
          docker.image(BUILDER_IMAGE).inside {
            sh 'go mod tidy'
            sh 'go build -v -o webserver .'
            sh 'ls -la ./webserver || true'
            sh 'echo "=== Build finished ==="'
          }
          archiveArtifacts artifacts: 'webserver', fingerprint: true
        }
      }
      post {
        failure {
          echo "Build failed — sprawdź logi powyżej"
        }
      }
    }

    stage('Test') {
      steps {
        script {
          echo "Running tests (inside builder image)"
          docker.image(BUILDER_IMAGE).inside {
            sh 'go test ./... -v 2>&1 | tee test-output.txt || true'
            sh 'cat test-output.txt'
          }
          archiveArtifacts artifacts: 'test-output.txt', fingerprint: true
        }
      }
      post {
        always {
          junit allowEmptyResults: true, testResults: '**/test-output.xml'
        }
        failure {
          error "Test stage failed — sprawdź test-output.txt i logi"
        }
      }
    }

    stage('Build runtime image') {
      steps {
        script {
          sh "docker build -t ${IMAGE_NAME}:${RUNTIME_TAG} ."
          sh "docker images | grep ${IMAGE_NAME} || true"
          sh "docker save ${IMAGE_NAME}:${RUNTIME_TAG} -o ${IMAGE_NAME}-${RUNTIME_TAG}.tar || true"
          archiveArtifacts artifacts: "${IMAGE_NAME}-${RUNTIME_TAG}.tar"
        }
      }
    }

    stage('Deploy') {
      steps {
        script {
          sh "docker rm -f webserver || true"
          sh "docker run -d --name webserver -p 8082:8082 ${IMAGE_NAME}:${RUNTIME_TAG}"
          sh "sleep 3"
          sh "docker ps --filter name=webserver --format 'table {{.Names}}\\t{{.Image}}\\t{{.Status}}'"
          sh "curl --fail -sS http://127.0.0.1:8082/ping || (echo 'ping failed'; docker logs webserver; exit 1)"
          echo "Deployed and ping OK"
        }
      }
    }

    stage('Publish') {
      when {
        expression {
          return env.DOCKER_CREDENTIALS_ID != null && env.DOCKER_CREDENTIALS_ID != ''
        }
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

  post {
    always {
      echo "Pipeline finished (status: ${currentBuild.currentResult})"
    }
  }
}
