<H1>README</H1>
<H1>Repo Name: package</H1>
<P>Purpose: To demonstrate how to create an Application EC2 AMI using Packer within a Jenkinsfile. These scrips are run after each successful build. The Base image was created manually with an UBUNTU OS Image and a TOMCAT installation. Packer uses that Base image to create the final Application AMI as part of the pipeline. This allows for a faster AMI build, because the pipeline is not re-creating the same base image after each successful application build</P>

<H1>Before running this repo, update the following items to reflect your repo information and envrionment</H1>

<UL>
<LI>Update Webhooks on Git Hub to reflect your Jenkins URL or IP
<LI>Update the git url to reflect your own Git Hub Repository
<LI>Update the download script download-artifacts.sh located in /usr/local/bin on the Jenkins server to specify your own Nexus URL or IP (1 location)
</UL>

<H1>TODO </H1>

<UL>
<LI>...
</UL>
