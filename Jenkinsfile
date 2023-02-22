pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
               withCredentials([usernamePassword(credentialsId: 'git-shay-ron', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
               sh "sudo docker build -t shayabudi/PolyBot-${env.Build_NUMBER} ."
               sh "sudo docker login --username $user --password $pass"
               sh "sudo docker push shayabudi/PolyBot-${env.Build_NUMBER}"




               sh 'echo building...'
            }
        }
        stage('Stage II') {
            steps {
                sh 'echo "stage II..."'
            }
        }
        stage('Stage III ...') {
            steps {
                sh 'echo echo "stage III..."'
            }
        }
    }
}
