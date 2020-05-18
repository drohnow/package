pipeline  {
  agent any; 

  options {
        disableConcurrentBuilds()
  }




   stages  {


   stage('Get Packer Repo') 
   { 
      steps {
        echo "Getting Packer Repo"
        git(
        url:'git@github.com:drohnow/package.git',
        credentialsId: 'package',
        branch: "master"
        )
     }

   }

   stage('Read Properties File') {
      steps {
        script {
           copyArtifacts(projectName: "${ProjectName}");
           props = readProperties file:"${fileProperties}";

           this_group = props.Group;
           this_version = props.Version;
           this_artifact = props.ArtifactId;
           this_full_build_id = props.FullBuildId; 
           this_jenkins_build_id = props.JenkinsBuildId; 
        }


        sh "echo Finished setting this_group = $this_group"
        sh "echo Finished setting this_version = $this_version"
        sh "echo Finished setting this_artifact = $this_artifact"
        sh "echo Finished setting this_full_build_id = $this_full_build_id"
        sh "echo Finished setting this_jenkins_build_id = $this_jenkins_build_id"

      }
    }


  stage('Download Artifacts') 
    {

     
        this_group = pom.groupId;
        this_artifact = pom.artifactId;
        this_version = pom.version;

        sh "/usr/local/bin/download-artifacts.sh  $this_group $this_artifact $this_version"
        echo "*** Test: ${pom.artifactId}, group: ${pom.groupId}, version ${pom.version}";

        def outputGroupId = "Group=" + "$this_group";
        def outputVersion = "Version=" + "$this_version";
        def outputArtifact = "ArtifactId=" + "$this_artifact";
        def outputFullBuildId = "FullBuildId=$this_artifact-$this_version" + ".war";
        def outputJenkinsBuildId = "JenkinsBuildId=${env.BUILD_ID}";
        def outputBuildNumber = "BuildNumber=${env.BUILD_NUMBER}";

        def allParams = "$outputGroupId" + "\n" + "$outputVersion" + "\n" + "$outputArtifact" + "\n" + "$outputFullBuildId" + "\n" + "$outputJenkinsBuildId" + "\n" + "$outputBuildNumber";

        //echo "PROJECT NAME from build: ${projectName}";
        //echo "PROJECT FULL NAME from build: ${fullProjectName}";
        echo "JOB_BASE_NAME from global: ${env.JOB_BASE_NAME}";
        echo "JOB NAME from global: ${env.JOB_NAME}";

        echo "this is allParams: $allParams";
        echo "File Properties designated location:  $filePropertiesPathAndName"

        // Create and Archive the properties file
        writeFile file: "$filePropertiesPathAndName", text: "$allParams"

   
        // Copy file properties to this directory and Archive 
        sh "cp $filePropertiesPathAndName .";
        archiveArtifacts artifacts: "${fileproperties}";
        echo "Completed --- download artifacts"


        sh "/usr/local/bin/download-artifacts.sh  $this_group $this_artifact $this_version"

        echo "*** List build download";
        sh 'ls -l'

     }

    }



    stage('Create app image')
    {
      steps {
        // Run packer 
        sh 'pwd'
        sh 'ls -l'
        echo "Starting --- packer validate"
   
        script {
             def varBuildId = "buildId=" + "$this_full_build_id";
             def varJenkinsBuildId = "jenkinsBuildId=" + "$this_jenkins_build_id";
             def varArtifactId = "artifactId=" + "$this_artifact";
 
             echo "This is varBuildId $varBuildId";
             echo "This is varJenkinsBuildId $varBuildId";
             echo "This is varArtifactId $varArtifactId";
 
             sh "/usr/local/bin/packer validate -var $varBuildId -var $varJenkinsBuildId -var $varArtifactId ./ami.json"

             echo "Starting --- packer build"
             sh "/usr/local/bin/packer build -var $varBuildId -var $varJenkinsBuildId -var $varArtifactId ./ami.json"

        }
      }
    }

   }  // End of Stages
    
}  // End of pipeline
   
