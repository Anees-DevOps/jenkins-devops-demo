pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Environment Information') {
            steps {
                sh '''
                    echo "======================================"
                    echo " Jenkins DevOps Pipeline"
                    echo "======================================"

                    echo "Build Number : ${BUILD_NUMBER}"
                    echo "Branch       : ${BRANCH_NAME:-main}"
                    echo "Node         : $(hostname)"
                    echo "Workspace    : ${WORKSPACE}"
                '''
            }
        }

        stage('Validate Configuration') {
            steps {
                sh '''
                    echo "Checking application configuration..."

                    test -f app/app.conf
                    test -f config/deployment.conf
                    test -x scripts/health-check.sh

                    echo "Required files are present."

                    echo
                    echo "Application configuration:"
                    cat app/app.conf

                    echo
                    echo "Deployment configuration:"
                    cat config/deployment.conf
                '''
            }
        }

        stage('Health Check') {
            steps {
                sh './scripts/health-check.sh'
            }
        }

        stage('Package') {
            steps {
                sh '''
                    rm -rf build
                    mkdir -p build

                    cp -r app config scripts README.md build/

                    echo "Build Number=${BUILD_NUMBER}" \
                        > build/build-info.txt

                    echo "Commit=${GIT_COMMIT:-manual}" \
                        >> build/build-info.txt

                    echo "Branch=${BRANCH_NAME:-main}" \
                        >> build/build-info.txt

                    tar -czf \
                        jenkins-demo-${BUILD_NUMBER}.tar.gz \
                        build/
                '''
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: '*.tar.gz',
                                 fingerprint: true
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed. Check the failed stage.'
        }

        always {
            echo "Build #${BUILD_NUMBER} finished."
        }
    }
}
