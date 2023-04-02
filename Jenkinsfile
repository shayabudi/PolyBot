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
                      catchError(message:'pytest ERROR-->even this fails,we continue on',buildResult:'UNSTABLE',stageResult:'UNSTABLE'){
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
                    catchError(message:'pylint ERROR',buildResult:'UNSTABLE',stageResult:'UNSTABLE'){

                            sh "python3 -m pylint *.py || true"

                   }
               }
            }
        }

        stage('Build Bot app') {
            steps {
                sh "docker build -t shayabudi8/polybot:poly-bot-${env.BUILD_NUMBER} . "



                }
         }
       stage('snyk test - Bot image') {
            steps {
                sh "snyk container test --severity-threshold=critical --policy-path=PolyBot/.snyk shayabudi/polybot:poly-bot-${env.BUILD_NUMBER} --file=Dockerfile || true"
            }
        }

        stage('push image to rep') {
            steps {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                      sh "echo '$PASS' | docker login --username $USER --password-stdin"
                     sh "docker push shayabudi8/polybot:poly-bot-${env.BUILD_NUMBER}"
                    }
           }
      }
  }
  
  post{
    always{
        sh "docker rmi shayabudi8/polybot:poly-bot-${env.BUILD_NUMBER}"
    }
  }
