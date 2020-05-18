node {
    echo "Starting Pipeline... "
    def mvnHome;
    def pom;

    def this_group;
    def this_artifact;
    def this_version; 
    def output;
    def this_full_build_id;
    def this_jenkins_build_id;
    def fileproperties = "file.properties";
    def filePropertiesPathAndName = "${JENKINS_HOME}/workspace/import-subsystem/${fileproperties}";

    stage('Get Build F iles') 
    { 
       echo "Getting Private Repo"
       git(
       url: 'git@github.com:drohnow/package.git',
       credentialsId: 'package',
       branch: "master"
       )



       mvnHome = tool 'M3'
    }


   
   

   
  
  stage('Create app image')
    {
      
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
 
             sh "/usr/local/bin/packer validate ./ami.json"

             echo "Starting --- packer build"
             sh "/usr/local/bin/packer build ./ami.json"

        
      }
    } 



}

