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
                    sh 'ng build --base-href /healthtracker/'
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

        stage('Build and push frontend image') {
            steps {
                dir('HealthTracker-frontend') {
                    script {
                        docker.withRegistry('https://ghcr.io/', 'ghcr_token') {
                            docker.build('ghcr.io/adesz88/health-tracker-frontend:latest', '--no-cache .').push('latest')
                        }
                    }
                }
            }
        }

        stage('Build and push backend image') {
            steps {
                dir('HealthTracker-backend') {
                    script {
                        docker.withRegistry('https://ghcr.io/', 'ghcr_token') {
                            docker.build('ghcr.io/adesz88/health-tracker-backend:latest', '--no-cache .').push('latest')
                        }
                    }
                }
            }
        }

        stage ('SSH') {
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
                            docker compose pull
                            docker compose down
                            docker compose up -d
                        """
                    }
                }   
            }
        }

        stage('Cleanup') {
            steps {
                deleteDir()
            }
        }
    }
}