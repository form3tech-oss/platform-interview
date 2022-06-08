**To @form3tech-interviewer-1**

My name is Javier Laglaive. I am an applicant for a Cloud Engineering job at Form3.

First of all, I am new to terraform. I started from scratch to understand how it works. The challenge is well designed to run quickly and figure out how things work in TF. After that, I have to read and research in order to improve the code of the challenge.

Second, I assume that the Vault container should be present (and running) before TF starts to apply the changes. Because of that, I added a section in "docker-compose.yml" for creating the vault container and network for the staging environment.

I tried to add the vault container creation at main.tf file, but the provider "vault" needs to do a checkup on the service and It did not work because the vault container was not running yet. I think maybe adding a dependency can solve the issue (I have to continue investigating)



**Improvement Strategy**

The main idea for improvement is to use a single environment description/deployment in the main.tf file.

The challenge is provided with 2 environment definitions in the main.tf duplicating all resources in it.

I used a feature called terraform workspaces. I created a workspace for each environment and applied the same main.tf deployment definition but with a different set of variables.

In this way, it is very easy to set up new environments. And of course, having only one file for deployment is better for maintenance and readability.

Variables were refactored from main.tf to a separate tfvars file according to their environment belonging.

Also, I explored another way to implement different environments using folders but that would imply having many copies of main.tf. That approach is the opposite of main goal.

I read about modules, but I did not explore the topic to see if it was applicable. As far as I can see, TF is very flexible and there are several ways to achieve the same goal.

  

**CI/CD Pipeline**

I am a sysadmin/maintainer of Jenkins infra in my current job position, but I am not an expert in the CI/CD pipelines. I learned how to do some things along the way. Having said that, I will describe how I would add this challenge exercise to a pipeline.

First: setup up a GHE-org or multibranch pipeline pulling/monitoring the Github repo.

Configure the pipeline to build every commit to master/main and any PR. The idea is to build/test the whole deployment when a developer commits to master or file a PR.

Second: Developers create a branch from the GitHub repo, modify the code, add new things, fix errors, etc. They run and test locally.

Third: When the development is finished a PR is made. CI/CD pipeline picks up the request, then builds and tests. CI/CD pipeline post the result to GitHub. If the pipeline runs ok and tests are ok, then they are ready to be merged into master/main safely.


**TODO**

-   Study on how modularize if this can help to simplify the deployment definition.
    
-   Try to include vault deployment in the same main.tf configuration file.
