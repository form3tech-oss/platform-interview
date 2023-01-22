* Design decisions

As the rules stated that I should not use other tooling than vanilla terraform, I opted
for the following design:

- Add a Makefile to ease operations
- Have a common terraform folder, which contains common iac resources. Symlink the common 
  terraform files in each environment
- Put each environment in a dedicated folder
- Add a config.yaml file for each environment, to define its specific config
- Have each environment symlink the common files, and call vault and docker terraform modules
- Create a template environment folder, to ease spinning up new environments
- Create 2 terraform modules: vault and docker
- Add a bash script to create a new environment from the template
- Modify run.sh, adding a bash for loop to parse all environments terraform files (except the  
  template)


* CICD flow

I would run the actual setup this way in a pipeline:

- A job to build the images for each microservice, if there are code changes
- Decide which deployment flow we want. For starters, I would deploy on master merges
- With the current vagrant deployment, it is not possible to assure high availability, as each 
  service runs with 1 container only, meaning that when a new image is deployed, there's downtime

  So assuming this, I would have a job to run `make deploy`, which applies the terraform in all environment folders

- Testing. As it is right now, it's not a very exciting app, but as features get added, we 
  should add some testing to the pipeline. 

  For example, quick, smoke tests for pull requests and full regression tests before deployments are allowed.
  
  All the testing should be run in architecturally identical, but ephemeral, clusters.


* PRODUCTION READINESS

Ok, so this exercise is over, and we are thinking to think about production readiness. Of course, the way it's architectured is not good enough.

I would start thinking and planning on:

- Depending on when this project is going to be run, the question comes about where to place the 
  load balancer/s. Lets assume the target is a cloud provider, AWS.
  
  I would use an AWS Network Load Balancer, and Nginx ingress. 
  https://github.com/kubernetes/ingress-nginx

  - DNS records. Annotate services that need dns records, with external-dns annotations in the charts

- If we run k8s in the cloud (EKS for example), ensure the worker nodes run at least in 2   
  availability zones. 
  
  EKS control planes already run in 3 availability zones.

  https://aws.github.io/aws-eks-best-practices/reliability/docs/controlplane/

- I would plan to k8size this setup, using a helm chart for each service

- Ensure each service runs at least 2 replicas for high availability

- Define good health and liveness probes for each service

- Define resource requests and limits. For starters, as probably we dont have enough historic 
  usage data, use Goldilocks to get resource usage insights. And once we have enough working data, set requests and limits. Iteration will be needed probably.

  Docs here https://github.com/FairwindsOps/goldilocks

- Refactor dockerfiles, in order to reduce attack vector and image size, use multistage builds.
  For go applications, use whatever you need for the build stage, and scratch as the base image for the final stage,as it needs only to run the go binary. (this is already done in this work)

- Security. Depending on which cloud we run, offload tls traffic into the load balancer, or 
  deploy cert-manager in the cluster, so tls traffic arrives at the cluster, and it's offloaded at the nginx-ingress proxies.

  Having cert-manager in-cluster adds logic to the flow, but eases vendor lock-in -compared to use AWS certificates.

  In this example, as I already proposed using an AWS NLB, I would offload tls certificates there. 

  Of course you could have end-to-end encryption as well,extra work but might be required in some high regulated industries. 

  So the flow would be: TLS offloaded at NLB- new tls handshake established, from the NLB to nginx-ingress, which will offer a Lets-encrypt certificate managed by cert-manager. Traffic inside the cluster would be HTTP.

  But, if we want to have end-to-end encryption as well inside the cluster, we should use a service mesh like Istio,to have full end-to-end encryption between microservices.
  
  But that adds extra complexity, and might not be needed in most usecases.

- Security II. Add a docker image vulnerability scanner at image build time, in the pipeline. 
  Use trivy for example as tooling. 

  Define some hard rules to abort the image build and deploy if there are too many critical vulnerabilities - so either fix those vulnerabilities if we maintain the image, or we should find a more secure base image 

- Use a gitops flow for the deploys. As tooling, Flux, argocd. Let's pick flux for example

- Create a kustomize flow for flux, in order to apply all the manifests required for each service

- Secrets management. We are keeping the app secrets in plain text in the repo. So let's use 
  sops and use AWS KMS for example, as a key backend
  
  This way secrets can be committed cyphered with the KMS key to the repo. And decrypt them automatically with flux.

- Secrets management II. We are running a local vault for each service, in a single container. 
  As designing vault setups can be quite complex, I would ensure, for now, they run locally, but with high availability (having 2 containers for each vault server)

- Testing. I already covered that in the CICD section.

- Storage. Currently, the services are stateless, but if in the future this changes, we need to 
  think about it. Adding PersistentVolumes as needed, and claiming them in the pods.

- Observability. Deploy grafana's LGTM stack in order to get full observability of the services
  https://github.com/grafana/helm-charts/tree/main/charts, using Loki, Grafana, Tempo, and Mimir.

  Depending on how many other products we run, it could pay off cost-wise, to have a centralized observability platform, using the same grafana LGTM stack, ship logs/metrics/traces from all the products to this central platform, and have dashboards and alerting

    - Alerting. Define alerting in grafana dashboards, and use grafana alerting to notify 
      whenever/however is needed, in case of app issues.  

- Cost savings. Depending on where this infrastructure is run, think about design 
  considerations. As it is now, this is a stateless application, so we do not need to care about storage considerations.
  
  About backend infrastructure, If for example, we run this on AWS, I would run this on EKS with spot instances - not with fargate, since it does not allow daemonsets to run.

  Running on spot instances allows for massive cost savings. You just need to define poddisruptionbudgets for each service, so in case of spot instance interruptions, replicas can be evicted from the
  soon-to-be-evicted node.

- CDN. The frontends do not run any static content right now, besides the sample Nginx page. But 
  in a normal application, static assets should be exposed as cdn resources.
