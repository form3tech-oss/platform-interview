I have done number of changes to the original "/tf" folder and also to Vagrantfile and docker-compose.yaml files.
I have to admit that I have limited real world experience with terraform and it is based on self-study (few months ago for another interview).

1. Added support for VMware Fusion to Vagrantfile using different ubuntu vagrant image - "hashicorp/bionic64". My old 2015 Macbook Pro had VMware Fusion already installed so this is more performant than vbox/multipass.
2. Added "staging" network and "staging" vault instance to docker-compose.yaml
3. I did not touch run.sh, but it will be the obvious place to edit if "staging" needs to run different version of service apps than "dev" and "prod" deployments.
   It will need additional "docker build" to build local docker images for new versions to use in "staging".
5. Inside "tf" folder I used number of dummy "modules" to make the structure more modularized and easy to manage in the future to accomodate additional app services and even more environments.
   - I added two subfolders under /tf root. although these service dummy modules I did not want to have too many layers of subfolder and put these under "modules" subfolder.
   - "environments" subfolder has different environemnts vault provider configs. The vault provider version is a bit odd and I could not find and easier way to use this version of the provider with environemtn variables.
     It does not support namespaces so I had to pass aliases for dev, prod and stage.
   - "services" subfolder passes the specific env vault providers and environment specific varibles to the below "service" module. "service" module generates each service app specifc infra deployment and vault config, so it is a reusable module.
     "services" folder above calls in a loop "service" module and also configures the frontend deployment and common vault config for all servce apps.
6. In the current TF structure the most important files to edit if adding new app servces or editing current apps configurations are at the root level directly under "/tf". If adding new environemts one needs laos to create new module inside "environments" subfolder.
   - "tf/variables.tf" defines top level environment and applcation variables. It needs editing if adding new service applications or a new environment.<img width="1097" alt="Screenshot 2023-10-23 at 16 30 24" src="https://github.com/nlinkov/platform-interview/assets/26972988/7d917634-b354-4974-896a-6b468db998de">

   - "tf/terraform.tfvars" defines top level parameters/values for environment and application variables. It needs editing if adding new service applications or a new environment.<img width="1090" alt="Screenshot 2023-10-23 at 16 30 37" src="https://github.com/nlinkov/platform-interview/assets/26972988/f62a047d-5668-42f0-8739-6009bac6978f">

   - "tf/main.tf" which calls the different environment modules defined under "environments" subfolder. It only needs editing if adding a new environment.<img width="1100" alt="Screenshot 2023-10-23 at 16 30 53" src="https://github.com/nlinkov/platform-interview/assets/26972988/3943d8b9-c38d-4623-b4f6-d701545bf317">

   - if adding new nevironemnt one needs to create new module under "environments" subfolder and to edit "environments/main.tf" and "environments/provider.tf".<img width="1142" alt="Screenshot 2023-10-23 at 16 31 14" src="https://github.com/nlinkov/platform-interview/assets/26972988/1cdec6bd-bc73-4327-b7d6-9ff82098350d">

7. What would I do different or additional:
   - I would separate service apps and have it in different repository from the overall static/infrastructure config/deployments.
   - I would streamline all infra deployments to be done in terraform and not have certain bits of infrastructure done by bash script, certain by docker-compose and others by terraform.
   - I would try to have common infrastructure deployment code for all environments and not have three or more subfolders under root terraform /tf folder.
     Potentially use either separate terraform workspacesfor dev/prod/stage or use separate git branches for each and have terraform state files in shared storage like S3 bucket in AWS (as a minimum for prod environment).
     I am not sure how I can pass at run time actuakl enviroenmtn name to current vault provider.
   - For "prod" and "staging" deployments I would use public cloud managed containerazation service with some loadbalancing , autoscaling etc.
   - I would setup in github actions CI/CD pipelines for both service apps repository and infrastructure deployment repositories with build and test steps in the CI parts - static code dependancy analysis, unit and integration tests.
     And use different devployments for dev, stage and prod depending on infrastructure used for each. If "dev" will be used primarily with locally with vagrant on developers laptops, probably no need for a deployment step in dev CI/CD. Staging CI/CD can deploy directly to containers in CGP with no need for vagrant for example.         Ideally should have staging as a complete infrastructure and app replica of prod.
8. Outstanding prbolems.
   - currently when deploying in WMare Fusion vagrant VM all three environments with three vault instances and 12 other docker containers 1-3 of the service apps randomly fail. I tested all possible combinations of deploying only two enffirnemtns and I do not get failures, but I only get random failures with full deployment with al apps and all environemnts. I have changed service apps DOckerfiles to use busybox in order to have shell access to running containers. My gut feeling is that wither docker side or vault instances are having intermittent issues as when starting new apps from within the containers I do not get 400 error but I do get the DB login credentials fine from vault instances.<img width="1277" alt="Screenshot 2023-10-23 at 17 19 01" src="https://github.com/nlinkov/platform-interview/assets/26972988/ac68e668-95ad-436c-b6f1-a0defdf1767b">
<img width="1278" alt="Screenshot 2023-10-23 at 17 20 14" src="https://github.com/nlinkov/platform-interview/assets/26972988/4d262fa0-489e-4239-ac3a-cd3023bfbb1e">

   - I have not tested yet if this issue is vagrant/Mac/VMware specific and might do in the next few days.
