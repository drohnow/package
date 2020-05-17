pipeline  {
  agent any; 

  options {
        disableConcurrentBuilds()
  }

  environment {
    this_group = ""
    this_version = ""
    this_artifact = ""
    this_full_build_id = ""
    this_jenkins_build_id= ""
    props = "";
    FilePropertiesLocation = "";
    ProjectName = "01-Build";
    fileProperties = "file.properties"

  }

    //ANOTHER_ENV = "${currentBuild.getNumber()}"
    //INHERITED_ENV = "\${BUILD_NUM_ENV} is inherited"



   stages  {


   stage('Get Packer Repo') 
   { 
      steps {
        echo "Getting Packer Repo"
        git(
        url:'git@github.com:drohnow/package.git',
        credentialsId: 'NEXUS_USER',
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
      steps {
        echo "Starting --- download artifacts"

        echo "this_group is $this_group"
        echo "this_version is $this_version"
        echo "this_artifact is $this_artifact"

        sh "/usr/local/bin/download-artifacts.sh  $this_group $this_artifact $this_version"
        echo "*** List build download";
        sh 'ls -l'
        echo "Completed --- download artifacts"

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
   
