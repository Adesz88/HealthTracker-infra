pipeline {
    agent any

    tools {
        nodejs 'Node 20'
    }

    environment {
        GITHUB_REPO = 'https://github.com/Adesz88/HealthTracker.git'
        BRANCH = 'main'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: env.BRANCH, url: env.GITHUB_REPO
            }
        }

        stage('Install frontend dependencies') {
            steps {
                dir('HealthTracker-frontend') {
                    sh 'npm ci'
                }
            }
        }

        stage('Build frontend') {
            steps {
                dir('HealthTracker-frontend') {
                    sh 'ng build'
                }
            }
        }

        stage('Test frontend') {
            steps {
                dir('HealthTracker-frontend') {
                    sh 'npm run ci-test'
                }
            }
        }

        stage('Build frontend image') {
            steps {
                dir('HealthTracker-frontend') {
                    script {
                        def frontendImage = docker.build 'adesz88/health-tracker-frontend:latest',  '--no-cache .'
                    }
                }
            }
        }

        stage('Install backend dependencies') {
            steps {
                dir('HealthTracker-backend') {
                    sh 'npm ci'
                }
            }
        }

        stage('Build backend') {
            steps {
                dir('HealthTracker-backend') {
                    sh 'npm run build'
                }
            }
        }

        stage('Build backend image') {
            steps {
                dir('HealthTracker-backend') {
                    script {
                        def backendImage = docker.build 'adesz88/health-tracker-backend:latest', '--no-cache .'
                    }
                }
            }
        }

        /*stage ('SSH') {
            steps {
                script{
                    def remote = [:]
                    remote.name = "Optiplex-7010"
                    remote.host = "192.168.0.55"
                    remote.allowAnyHosts = true
                    remote.failOnError = true
                    withCredentials([usernamePassword(credentialsId: 'ssh_credentials', passwordVariable: 'password', usernameVariable: 'username')]) {
                        remote.user = username
                        remote.password = password
                        sshCommand remote: remote, command: """
                            cd Docker/HealthTracker-infra
                            pwd
                            docker compose pull
                            docker compose down
                            docker compose up -d
                        """
                    }
                }   
            }
        }*/

        stage('Cleanup') {
            steps {
                // Munkaterület tisztítása
                deleteDir()
            }
        }
    }
}