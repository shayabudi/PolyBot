pipeline {

    options {
        buildDiscarder(logRotator(daysToKeepStr: '10', numToKeepStr: '10'))
        disableConcurrentBuilds()
        timestamps()
        //retry(2)
        timeout(time: 3, unit: 'MINUTES')
    }

        
    agent{
         docker{
              image 'jenkins-agent:latest'
              args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
           }
    }

    //insert credential to environment variable
    environment{
      SNYK_TOKEN=credentials('snyk-token')
    }


    stages {
        stage('test') {
            parallel{
              stage('pytest'){
                   steps{
                      withCredentials([file(credentialsId: 'telegramToken', variable: 'TELEGRAM_TOKEN')])
                      {
                       sh "cp ${TELEGRAM_TOKEN} .telegramToken"
                       sh 'pip3 install -r requirements.txt'
                       sh "python3 -m pytest --junitxml results.xml tests/*.py"
                     }
                   }
               }

                stage('pylint'){
                   steps{

                            sh "python3 -m pylint *.py || true"

                   }
               }
            }
        }

        stage('Build Bot app') {
            steps {
                sh "docker build -t shayabudi/polybot:poly-bot-${env.BUILD_NUMBER} . "
                 withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                      sh "echo '$PASS' | docker login --username $USER --password-stdin"

                    }
                }
         }
       stage('snyk test - Bot image') {
            steps {
                sh "snyk container test --severity-threshold=critical --policy-path=PolyBot/.snyk shayabudi/polybot:poly-bot-${env.BUILD_NUMBER} --file=Dockerfile || true"
            }
        }

        stage('push image to rep') {
            steps {
                     sh "docker push shayabudi/polybot:poly-bot-${env.BUILD_NUMBER}"
                    }
           }
      }
  }
  
  post{
    always{
        sh "docker rmi shayabudi/polybot:poly-bot-${env.BUILD_NUMBER}"
    }
  }

