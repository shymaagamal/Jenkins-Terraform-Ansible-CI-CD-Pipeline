pipeline {
    agent { label 'slave' }  
    stages {
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
            when{
                changeset "**/terraform**"
            }
            steps{
                echo '✅ Terraform folder changed. Running terraform apply...'

                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'shaimaa-aws-access']]){
                    dir('terraform'){
                      sh 'terraform init'
                      sh 'terraform plan'
                      sh 'terraform apply -auto-approve'

                    }
                }

            }
        }


        stage('Ansible Playbook'){
          when {
            changeset "**/ansible/**"
          }
            steps{
              echo '📦 Ansible folder changed. Syncing to bastion and executing playbooks...'
              withCredentials([sshUserPrivateKey(credentialsId: 'bastion-access', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                dir('ansible'){
                    sh """
                       rsync -avz -e "ssh -i $SSH_KEY -o StrictHostKeyChecking=no" ./ansible/ ubuntu@44.195.38.202:/home/ubuntu/
      
                    """
                    // Run Ansible Playbooks *on the bastion host*
                    sh """
                      echo "SSH_USER is $SSH_USER"
                      ssh -i $SSH_KEY -o StrictHostKeyChecking=no $SSH_USER@44.195.38.202 << 'EOF'
                        cd /home/ubuntu/ansible
                        ansible-playbook plays/app.yaml
                        ansible-playbook plays/jenkins-master.yaml
                        ansible-playbook plays/jenkins-slave.yaml
                      EOF
                    """

                }
              }
            }
        }
    }
}