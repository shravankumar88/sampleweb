pipeline{
	agent any
		
	environment{
		BUILD_ID="${env.BUILD_ID}"
		JOB_NAME="${env.JOB_NAME}"
		BUILD_NUMBER="${env.BUILD_NUMBER}"
			}
	stages{
		stage('MVN Package'){
			steps{
				sh "mvn package"
			}
		}
		stage('QualityGateStatusCheck'){
		agent{
			docker{
				image'maven'
				args'-v$HOME/.m2:/root/.m2'
				}
			}
			steps{
				script{
					withSonarQubeEnv('sonarqube')
					{
						sh"mvn clean package sonar:sonar"
					}
						//timeout(time:1,unit:'MINUTES'){
						//defqg=waitForQualityGate()
						//if(qg.status!='OK'){
						//error"Pipelineabortedduetoqualitygatefailure:${qg.status}"
						//}
						//}
					}
				}
			}
		stage("dockerbuild&dockerpush"){
			steps{
				script{
					withCredentials([
					string(credentialsId:'jfrog_url',variable:'jfrog_url'),
					string(credentialsId:'docker_un',variable:'docker_username'),
					string(credentialsId:'docker_pass',variable:'docker_password')])
						{
						sh'''
						docker build -t $jfrog_url/code-docker/${JOB_NAME}:${BUILD_ID} .
						docker login -u $docker_username -p $docker_password $jfrog_url
						docker push $jfrog_url/code-docker/${JOB_NAME}:${BUILD_ID}
						docker rmi $jfrog_url/code-docker/${JOB_NAME}:${BUILD_ID}
						'''
						}
					}
				}
			}
			stage("indentifying misconfig using datree in helm charts"){
				steps{
					dir('/var/lib/jenkins/workspace/sampleweb/kubernetes/') {
							sh 'helm datree test myapp/'
						}
	
			}
		}
	}
}