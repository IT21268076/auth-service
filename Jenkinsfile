pipeline {
    agent any

    environment {
        PROJECT_ID = credentials('GCP_PROJECT_ID')
        CLUSTER_NAME = 'auth-service-cluster'
        CLUSTER_ZONE = 'us-central1-a'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        IMAGE_NAME = "gcr.io/${PROJECT_ID}/auth-service"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh './mvnw test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('SonarCloud Analysis') {
            environment {
                SONAR_TOKEN = credentials('SONAR_TOKEN')
            }
            steps {
                withSonarQubeEnv('SonarCloud') {
                    sh "./mvnw sonar:sonar -Dsonar.projectKey=auth-service -Dsonar.organization=your-organization -Dsonar.host.url=https://sonarcloud.io -Dsonar.login=${SONAR_TOKEN}"
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('OWASP Dependency-Check') {
            steps {
                sh './mvnw dependency-check:check'
                dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
            }
        }

        stage('Push to GCR') {
            steps {
                sh "gcloud auth configure-docker --quiet"
                sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                sh "docker push ${IMAGE_NAME}:latest"
            }
        }

        stage('Deploy to GKE') {
            steps {
                sh "gcloud container clusters get-credentials ${CLUSTER_NAME} --zone ${CLUSTER_ZONE} --project ${PROJECT_ID}"
                sh "kubectl set image deployment/auth-service auth-service=${IMAGE_NAME}:${IMAGE_TAG}"
                sh "kubectl rollout status deployment/auth-service"
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
        always {
            cleanWs()
        }
    }
}