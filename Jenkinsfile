

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
    //insert to specific environment variable (must to this name: SNYK_TOKEN) my snyk's token
    environment{
        SNYK_TOKEN=credentials('snykToken')
    }


    stages {
        stage('Test') {
           parallel {
                   stage('pytest'){
                        steps{
                        catchError(message:'pytest ERROR-->even this fails,we continue on',buildResult:'UNSTABLE',stageResult:'UNSTABLE'){
                        withCredentials([file(credentialsId: 'telegramToken', variable: 'TOKEN_FILE')]) {
                            sh "cp ${TOKEN_FILE} ./.telegramToken"
                            sh 'pip3 install --no-cache-dir -r requirements.txt'
                            sh 'python3 -m pytest --junitxml results.xml tests/*.py'
                                     }//close Credentials
                                 }//close catchError
                             }//close steps
                        }//close stage pytest

           stage('pylint') {
                         steps {
                         catchError(message:'pylint ERROR-->even this fails,we continue on',buildResult:'UNSTABLE',stageResult:'UNSTABLE'){
                              script {
                                     
                                     sh "python3 -m pylint *.py || true"
                                     }
                                  }//close catchError
                               }//close steps
                           }//close stage pylint
                   }//close parallel
              }//close stage Test


        stage('Build Bot app') {
             steps {
                  sh "docker build -t shayabudi8/polybot:poly-bot-${env.BUILD_NUMBER} . "
                   }
                              }


        stage('snyk test - Bot image') {
            steps {
                sh "snyk container test --severity-threshold=critical --policy-path=PolyBot/.snyk shayabudi8/polybot:poly-bot-${env.BUILD_NUMBER} --file=Dockerfile || true"
                  }
                                        }

        stage('push image to rep') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'pass', usernameVariable: 'user')]){
                    sh "docker login --username $user --password $pass"
                    sh "docker push shayabudi8/shani-repo:poly-bot-${env.BUILD_NUMBER}"
                     }//close Credentials
                  }//close steps
         }//close stage push


    }//close stages
      post{
            always{
                sh "docker rmi shayabudi8/shani-repo:poly-bot-${env.BUILD_NUMBER}"
                  }
          }

}//close pipeline
