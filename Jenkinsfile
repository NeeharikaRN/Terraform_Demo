pipeline {
    agent any
    
    environment {
        AWS_ACCESS_KEY_ID = ""
        AWS_SECRET_ACCESS_KEY = ""
    }
    
    stages {
        stage('Checkout Terraform Project') {
            steps {
                git branch: 'main', url: 'https://github.com/NeeharikaRN/Terraform_Demo.git'
            }
        }
        
        stage('INIT') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        bat 'terraform init'
                    }
                }
            }
        }
        
        stage('SANITY CHECK') {
            steps {
                script {
                        bat 'terraform validate'
                }
            }
        }
        
        stage('PLAN') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        bat 'terraform plan -out "s3.tfplan"'
                    }
                }
            }
        }
        
        stage('FORMAT') {
            steps {
                script {
                    bat 'terraform fmt'
                }
            }
        }
        
        stage('Approval') {
            steps {
                script {
                    input 'Proceed to apply Terraform changes?'
                }
            }
        }
        
        /* stage('APPLY') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        bat 'terraform apply "s3.tfplan"'
                    }
                }
            }
        } */

        stage('ACTION'){
            steps {
                script {
                    // Request user input
                    def userInput = input(
                        message: 'What do you want to do?',
                        parameters: [
                            choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Select the action to perform')
                        ]
                    )
                    
                    // Store the user's choice
                    env.USER_ACTION = userInput

		    if (env.USER_ACTION == 'apply') {
                        bat 'terraform apply -auto-approve tfplan'
                    } else if (env.USER_ACTION == 'destroy') {
                        bat 'terraform destroy -auto-approve'
                    }
                }
            }
        }
        
        stage('RESOURCES LIST') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        bat 'terraform state list'
                    }
                }
            }
        }
    }
}
