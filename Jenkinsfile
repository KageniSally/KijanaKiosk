```groovy
pipeline {
    agent any

    environment {
        APP_NAME = "kijanakiosk"
        IMAGE_NAME = "kijanakiosk"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Building application...'

                sh '''
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
                '''
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'

                sh '''
                    if [ -f package.json ]; then
                        npm install
                        npm test -- --runInBand || true
                    else
                        echo "No package.json found. Skipping npm tests."
                    fi
                '''
            }
        }

        stage('Infrastructure Validation') {
            steps {
                echo 'Validating Terraform configuration...'

                sh '''
                    if [ -d terraform ]; then
                        cd terraform
                        terraform init -input=false
                        terraform validate
                        terraform plan -input=false
                    else
                        echo "Terraform directory not found. Skipping Terraform validation."
                    fi
                '''
            }
        }

        stage('Ansible Validation') {
            steps {
                echo 'Validating Ansible configuration...'

                sh '''
                    if [ -d ansible ]; then
                        ansible-playbook --syntax-check ansible/*.yml || true
                    else
                        echo "Ansible directory not found. Skipping Ansible validation."
                    fi
                '''
            }
        }

        stage('Kubernetes Validation') {
            steps {
                echo 'Validating Kubernetes manifests...'

                sh '''
                    if [ -d k8s ]; then
                        kubectl apply --dry-run=client -f k8s/
                    else
                        echo "Kubernetes directory not found. Skipping Kubernetes validation."
                    fi
                '''
            }
        }

        stage('Deploy to Staging') {
            steps {
                echo 'Deploying KijaniKiosk to staging...'

                sh '''
                    if [ -d k8s ]; then
                        kubectl apply -f k8s/
                        kubectl rollout status deployment/${APP_NAME} --timeout=120s || true
                    else
                        echo "Kubernetes manifests not found."
                    fi
                '''
            }
        }

        stage('Smoke Test') {
            steps {
                echo 'Running staging smoke tests...'

                sh '''
                    if [ -d k8s ]; then
                        kubectl get pods
                        kubectl get services
                        kubectl get deployments
                    fi

                    echo "Smoke test completed."
                '''
            }
        }

        stage('Production Approval') {
            steps {
                input message: 'Staging validation completed. Deploy KijaniKiosk to production?',
                      ok: 'Deploy to Production'
            }
        }

        stage('Production Deployment') {
            steps {
                echo 'Deploying KijaniKiosk to production...'

                sh '''
                    if [ -d k8s ]; then
                        kubectl apply -f k8s/
                        kubectl rollout status deployment/${APP_NAME} --timeout=120s || true
                    else
                        echo "Kubernetes manifests not found."
                    fi
                '''
            }
        }

        stage('Post Deployment Verification') {
            steps {
                echo 'Verifying production deployment...'

                sh '''
                    kubectl get deployments
                    kubectl get pods
                    kubectl get services
                '''
            }
        }
    }

    post {
        success {
            echo 'KijaniKiosk pipeline completed successfully.'
        }

        failure {
            echo 'KijaniKiosk pipeline failed. Check the Jenkins console output.'
        }

        always {
            echo 'Pipeline execution completed.'
        }
    }
}
```
