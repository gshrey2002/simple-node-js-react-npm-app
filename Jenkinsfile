pipeline {
    agent {
        docker {
            image 'node:6-alpine'
            args '-p 3000:3000'
        }
    }
     environment {
            CI = 'true'
        }
    stages {
        stage('Build') {
            steps {
                sh 'npm install'
            }
        }
        stage('Test') {
                    steps {
                        sh './jenkins/scripts/test.sh'
                    }
                }
                stage('docker image') {
                    environment{
                        DOCKER_IMAGE = "gshrey2002/nodecicd:${BUILD_NUMBER}"
                        REGISTRY_CREDENTIALS = credentials('dockerhub')
                    }
                            steps {
                                echo 'building docker image'
                                SCRIPT{
                                
                                sh 'docker build -t ${DOCKER_IMAGE} .'
                                SH 'docker run -d -it '
                                def dockerImage = docker.image("${DOCKER_IMAGE}")
                                docker.withRegistry('https://index.docker.io/v1/', "dockerhub") {
                                dockerImage.push()
                                }
                              
                            }
                        }
                        stage{
                            environment{
                                GIT_REPO_NAME = "simple-node-js-react-npm-app"
                                GIT_USER_NAME = "gshrey2002"
                            }
                            steps{
                                echo 'updating deployment file'
                                 steps {
                            withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                            sh '''
                            git config user.email "guptashrey163@gmail.com"
                            git config user.name "Shrey"
                            BUILD_NUMBER=${BUILD_NUMBER}
                            sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" simple-node-js-react-npm-app/manifest/deployment.yaml
                            git add simple-node-js-react-npm-app/manifest/deployment.yaml
                            git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                            git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
                            '''
                            }
        }
                            }

                        }


    }
}