// Jenkins Pipeline for rasylhan-aldiyar-devops
// Job name in Jenkins: Rasylhan_Aldiyar_DevOps
pipeline {
    agent any

    environment {
        STUDENT_NAME    = 'Aldiyar'
        STUDENT_SURNAME = 'Rasylhan'
        STUDENT_GROUP   = 'IT2-2309'
        STUDENT_ID      = '37838'
        IMAGE_NAME      = 'rasylhan-aldiyar-devops'
        CONTAINER_NAME  = 'rasylhan-aldiyar-container'
    }

    stages {
        stage('Checkout') {
            steps {
                // Takes the code from the GitHub repository configured in the job
                checkout scm
                sh 'echo "Commit used by Jenkins:" && git log -1 --pretty=format:"%H %an %s" && echo'
            }
        }

        stage('Build') {
            steps {
                sh '''
                    echo "Student: $STUDENT_NAME $STUDENT_SURNAME"
                    echo "Group: $STUDENT_GROUP"
                    echo "Student ID: $STUDENT_ID"
                    chmod +x scripts/*.sh tests/*.sh
                    bash -n scripts/*.sh
                    ls -la
                '''
            }
        }

        stage('Test') {
            steps {
                sh './tests/check_project.sh'
            }
        }

        stage('Docker Build') {
            steps {
                // Unit tests of the Python app also run inside docker build (RUN step)
                sh 'docker build -t $IMAGE_NAME:$BUILD_NUMBER -t $IMAGE_NAME:latest .'
                sh 'docker images $IMAGE_NAME'
            }
        }

        stage('Docker Run') {
            steps {
                sh '''
                    docker rm -f $CONTAINER_NAME 2>/dev/null || true
                    docker run --name $CONTAINER_NAME \
                        -e STUDENT_NAME="$STUDENT_NAME" \
                        -e STUDENT_SURNAME="$STUDENT_SURNAME" \
                        -e STUDENT_GROUP="$STUDENT_GROUP" \
                        -e STUDENT_ID="$STUDENT_ID" \
                        $IMAGE_NAME:latest
                    docker ps -a --filter name=$CONTAINER_NAME
                    docker logs $CONTAINER_NAME | grep "Application is running successfully!"
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline of ${env.STUDENT_SURNAME} ${env.STUDENT_NAME} finished successfully"
        }
        failure {
            echo 'Pipeline failed: check the stage marked in red and its Console Output'
        }
    }
}
