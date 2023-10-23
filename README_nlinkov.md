I have done number of changes to the original "/tf" folder and also to Vagrantfile and docker-compose.yaml files:
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
   - "tf/variables.tf" defines top level environment and applcation variables. It needs editing if adding new service applications or a new environment.
   - "tf/terraform.tfvars" defines top level parameters/values for environment and application variables. It needs editing if adding new service applications or a new environment.
   - "tf/main.tf" which calls the different environment modules defined under "environments" subfolder. It only needs editing if adding a new environment.
   - if adding new nevironemnt one needs to create new module under "environments" subfolder and to edit "environments/main.tf" and "environments/provider.tf".
7. What would I do different:
   - I would separate service apps and have it in different repository from the overall static/infrastructure config/deployments.
   - I would streamline all infra deployments to be done in terraform and not have certain bits of infrastructure done by bash script, certain by docker-compose and others by terraform.
   - I would try to have common infrastructure deployment code for all environments and not have three or more subfolders under root terraform /tf folder.
     Potentially use either separate terraform workspacesfor dev/prod/stage or use separate git branches for each and have terraform state files in shared storage like S3 bucket in AWS (as a minimum for prod environment).
     I am not sure how I can pass at run time actuakl enviroenmtn name to current vault provider.
   - For "prod" and "staging" deployments I would use public cloud managed containerazation service with some loadbalancing , autoscaling etc.
