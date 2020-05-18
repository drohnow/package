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
 
             sh "/usr/local/bin/packer validate -var $varBuildId -var $varJenkinsBuildId -var $varArtifactId ./ami.json"

             echo "Starting --- packer build"
             sh "/usr/local/bin/packer build -var $varBuildId -var $varJenkinsBuildId -var $varArtifactId ./ami.json"

        
      }
    }    
   
    stage('Publish to NEXUS') 
    {
 
       pom = readMavenPom file: "./pom.xml";
       // Read POM xml file using 'readMavenPom' step , 
       // this step 'readMavenPom' is included in: https://plugins.jenkins.io/pipeline-utility-steps

       // Find built artifact under target folder
        
       filesByGlob = findFiles(glob: "target/*.${pom.packaging}");

       // Print some info from the artifact found
       echo "*** Print information found";
       echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"

       // Extract the path from the File found
       artifactPath = filesByGlob[0].path;
       artifactName = filesByGlob[0].name;
       echo "*** this artifactName is: ${artifactName}";
       echo "*** this artifactPath is: ${artifactPath}";
       // Assign to a boolean response verifying If the artifact name exists
       artifactExists = fileExists artifactPath;
                   
       if(artifactExists) 
       {
          echo "*** File: ${artifactPath}, Path found";
          echo "*** File: ${artifactPath}, artifactId: ${pom.artifactId}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";
      
       // Upload artifact to Nexus using plugin 

       nexusArtifactUploader artifacts: [[artifactId: pom.artifactId, classifier: '', file: artifactPath, type: pom.packaging]], credentialsId: 'NEXUS_USER', groupId: pom.groupId, nexusUrl: '54.151.85.90:8081/', nexusVersion: 'nexus3', protocol: 'http', repository: 'devops-test-repo-snapshot/', version: pom.version 


       }
       else 
       {
          error "*** File: ${artifactPath}, could not be found";
       }
 
       withEnv(["MVN_HOME=$mvnHome"]) 
       {
          // sh '"$MVN_HOME/bin/mvn" -DrepositoryId=nexus -Dmaven.test.skip=true clean deploy'
       }

   }

    stage('Download Artifacts') 
    {
     // Download artifacts from Nexus
     echo "Starting --- download artifacts"
     dir('./download')
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
  
  



}

