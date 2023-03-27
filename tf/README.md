  - [ ] Your design decisions, if you are new to Terraform let us know
  
  I have decided to segregate environments by creating one folder for each, since it provides better isolation and reduces the risk of human error when executing tests locally. 
  I created a terraform module named service_setup, which comprises vault resources and the docker container, since those are required every time a new application is created.
  Credentials are on tfvars, but the is to move all sensitive variable to Github Secrets, for example.  Another option would be to use SOPS to encrypt credentials. 

  - [ ] How your code would fit into a CI/CD pipeline


  On a CI/CD pipeline I would:
    - Use atlantis if available.
    - I would version the terraform module
    - Add a stage to build applications
    - Add a checkov stage to improve security (e.g.: garantee no secrets are clear text). It would run in every push to the branch
    - If on demand development environment is required, we could have a plan and apply stage for Development which runs when the pull request title has a symbol e.g: "My pull request @dev0. But the could would need to be adapted so resources do not conflict because of same name. Otherwise dev is ran only on dev's machine
    - add the apply stage (Run after pull request is approved)
    - Sensitive variables would be saved as secrets in the CI/CD and passed as tf var during pipeline run. Depending on company policy, developers could be able to store and update secrets using a slack app that interacts with Vault API instead. 
  
  - [ ] Anything beyond the scope of this task that you would consider when running this code in a real production environment

  In terms of repository structure, on real production environment, considering different teams have ownership over each application. I would structure the repository to segregate applications. E.g:
     |
     |--account
          |--main.tf
          |--vars
              |--staging.tfvars 
              |--production.tfvars
     |
     |--gateway
          |--main.tf
          |--vars
              |--staging.tfvars 
              |--production.tfvars
  This way teams could work without blocking each other due to state locks. It is also a batter approach to manage ownership over each folder, which can be done setting proper owners on CODEOWNERS. At this point I would not create a repository for each application, but I would consider if the complexity of the repository increases. 

  There is a lot to consider regarding availability, security, performance, monitoring, logging, which I will be glad to discuss
