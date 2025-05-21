pipeline {
    agent { label 'slave' }  

    stages {
        stage('Test Webhook') {
            steps {
                echo '✅ Hello, World! Webhook is working!'
            }
        }
        stage('Install Terraform if Needed') {
          steps {
                sh '''
                  if ! command -v terraform &> /dev/null
                  then
                      echo "Terraform not found. Installing..."
                      sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
                      wget -O- https://apt.releases.hashicorp.com/gpg | \
                      gpg --dearmor | \
                      sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
                      gpg --no-default-keyring \
                      --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
                      --fingerprint
                      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
                      sudo apt update
                      sudo apt-get install terraform
                    else
                      echo "Terraform is already installed."
                    fi
                    terraform version
                '''
        }
      }
       stage('Terraform Apply'){
            steps{
                echo '✅ Terraform folder changed. Running terraform apply...'

                withCredentials([
                                    [$class: 'AmazonWebServicesCredentialsBinding',
                                    credentialsId: 'shaimaa-aws-access',
                                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
                                    sessionTokenVariable: 'AWS_SESSION_TOKEN'  // optional, needed if using temporary creds
                                    ]
                                    ]) {
                    dir('terraform'){
                      sh '''
                        echo "Injected AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID: -4}"
                        '''
 
                      sh 'terraform init'
                      sh 'terraform plan'
                      sh 'terraform apply -auto-approve'

                    }
                }

            }
        }

    }
}
