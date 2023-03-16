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

        stage('Build Bot app') {
            steps {
                  sh "docker build -t shaniben/shani-repo:poly-bot-${env.BUILD_NUMBER} . "
                }
            }

        stage('snyk test - Bot image') {
            steps {
                sh "snyk container test --severity-threshold=critical --policy-path=PolyBot/.snyk shaniben/shani-repo:poly-bot-${env.BUILD_NUMBER} --file=Dockerfile || true"
            }
        }

        stage('push image to rep') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-shani', passwordVariable: 'pass', usernameVariable: 'user')]){

                    sh "docker login --username $user --password $pass"
                    sh "docker push shaniben/shani-repo:poly-bot-${env.BUILD_NUMBER}"
                    }
           }
      }
  }
  
  post{
    always{
        sh "docker rmi shaniben/shani-repo:poly-bot-${env.BUILD_NUMBER}"
    }
  }
  
  
  
  
  
}
