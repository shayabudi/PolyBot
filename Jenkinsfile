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
    //environment{
      //  SNYK_TOKEN=credentials('snyk-token')
    //}


    stages {

        stage('Build Bot app') {
            steps {
                  sh "docker build -t shayabudi/PolyBot:poly-bot-${env.BUILD_NUMBER} . "
                }
            }

       stage('snyk test - Bot image') {
            steps {
                sh "snyk container test --severity-threshold=critical --policy-path=PolyBot/.snyk shayabudi/PolyBot:poly-bot-${env.BUILD_NUMBER} --file=Dockerfile || true"
            }
        }

        stage('push image to rep') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'pass', usernameVariable: 'user')]){

                    sh "docker login --username $user --password $pass"
                    sh "docker push shayabudi/PolyBot:poly-bot-${env.BUILD_NUMBER}"
                    }
           }
      }
  }
  
  //post{
    //always{
      //  sh "docker rmi shayabudi/polybot:poly-bot-${env.BUILD_NUMBER}"
    //}
  //}
  
  
  
  
  
}
