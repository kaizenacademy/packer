template = '''
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: packer
  name: packer
spec:
  containers:
  - command:
    - sleep
    - "3600"
    image: hashicorp/packer
    name: packer
    '''
def buildNumber = env.BUILD_NUMBER

if( env.BRANCH_NAME == "dev" ) {
    region = "us-east-1"
}
else if ( env.BRANCH_NAME == "qa" ) {
    region = "us-east-2"
}

else if ( env.BRANCH_NAME == "master" ) {
    region = "us-west-1"
}

else {
    error 'Branch doesn\'t match environment'
}

podTemplate(cloud: 'kubernetes', label: 'packer', showRawYaml: false, yaml: template){
    node("packer"){
    container("packer"){
    stage("Clone repo"){
       git branch: 'main', url: 'https://github.com/kaizenacademy/packer.git'
    }

    withCredentials([usernamePassword(credentialsId: 'aws-creds', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
    withEnv(["AWS_REGION=${region}"]) {
    stage("Packer version"){
        sh "packer build -var 'jenkins_build_number=${buildNumber}' ./adilet.pkr.hcl"

        build job: 'terraform-ec2', parameters: [string(name: 'action', value: 'apply'), string(name: 'region', value: "${region}"), string(name: 'ami_name', value: "my-ami-${buildNumber}"), string(name: 'az', value: "${region}b")]
    }
}
    }
    }
    }
}
