# Form3 Platform Interview

Platform engineers at Form3 build highly available distributed systems using infrastructure as code. Our take home test is designed to evaluate real world activities that are involved with this role. We recognise that this may not be as mentally challenging and may take longer to implement than some algorithmic tests that are often seen in interview exercises. Our approach however helps ensure that you will be working with a team of engineers with the necessary practical skills for the role (as well as a diverse range of technical wizardry).


## 🧪 Sample application
The sample application consists of three services:

```
┌─────────────┐     ┌──────────────┐    ┌──────────────┐
│             │     │              │    │              │
│   payment   │     │   account    │    │   gateway    │
│             │     │              │    │              │
└─────────┬───┘     └──────┬───────┘    └──────┬───────┘
          │                │                   │
          │                │                   │
          │                ▼                   │
          │         ┌──────────────┐           │
          │         │              │           │
          └────────►│    vault     │◄──────────┘
                    │              │
                    └──────────────┘
```                    

Each service connects to [vault](https://www.vaultproject.io/) to retrieve database credentials.

The project structure is as follows:

```
.
├── README.md
├── Vagrantfile
├── docker-compose.yml
├── services
│   ├── account
│   ├── gateway
│   └── payment
├── tf
│   ├── main.tf

```
1. The `tf\main.tf` is the sole focus of this test.
1. The `Vagrantfile` and `docker-compose.yml` is used to bootstrap this sample application and can be ignored.
1. The `services` code is used to simulate a micro services architecture that connects to vault to retrieve database credentials. The code and method of connecting to vault can be ignored for the purposes of this test.  

## 👟 Running the sample application
- make sure you have installed the [vagrant prerequisites](https://learn.hashicorp.com/tutorials/vagrant/getting-started-index#prerequisites)
- in a terminal execute `vagrant up`
- once the vagrant image has started you should see a successful terraform apply:
```
default: vault_audit.audit_dev: Creation complete after 0s [id=file]
    default: vault_generic_endpoint.account_production: Creation complete after 0s [id=auth/userpass/users/account-production]
    default: vault_generic_secret.gateway_development: Creation complete after 0s [id=secret/development/gateway]
    default: vault_generic_endpoint.gateway_production: Creation complete after 0s [id=auth/userpass/users/gateway-production]
    default: vault_generic_endpoint.payment_production: Creation complete after 0s [id=auth/userpass/users/payment-production]
    default: vault_generic_endpoint.gateway_development: Creation complete after 0s [id=auth/userpass/users/gateway-development]
    default: vault_generic_endpoint.account_development: Creation complete after 0s [id=auth/userpass/users/account-development]
    default: vault_generic_endpoint.payment_development: Creation complete after 1s [id=auth/userpass/users/payment-development]
    default: 
    default: Apply complete! Resources: 16 added, 6 changed, 0 destroyed.
    default: 
    default: ~
```
*Verify the services are running*

- `vagrant ssh`
- `docker ps` should show all containers running:

```
CONTAINER ID   IMAGE                         COMMAND                  CREATED          STATUS          PORTS                                       NAMES
94cc6d5f03bf   vagrant_account-production    "/go/bin/account"        16 minutes ago   Up 15 minutes                                               vagrant_account-production_1
0db8a7d9ba16   vagrant_payment-production    "/go/bin/payment"        16 minutes ago   Up 15 minutes                                               vagrant_payment-production_1
7c40ee590685   vagrant_gateway-production    "/go/bin/gateway"        16 minutes ago   Up 15 minutes                                               vagrant_gateway-production_1
e3a3d67b4c95   vagrant_payment-development   "/go/bin/payment"        16 minutes ago   Up 15 minutes                                               vagrant_payment-development_1
f5e64123c033   vagrant_account-development   "/go/bin/account"        16 minutes ago   Up 15 minutes                                               vagrant_account-development_1
c42e3e7193bf   vagrant_gateway-development   "/go/bin/gateway"        16 minutes ago   Up 15 minutes                                               vagrant_gateway-development_1
fb29bd20f3d0   vault:1.8.3                   "docker-entrypoint.s…"   16 minutes ago   Up 16 minutes   0.0.0.0:8201->8200/tcp, :::8201->8200/tcp   vagrant_vault-development_1
ca8c824503c4   vault:1.8.3                   "docker-entrypoint.s…"   16 minutes ago   Up 16 minutes   0.0.0.0:8301->8200/tcp, :::8301->8200/tcp   vagrant_vault-production_1

```

## ⚙️ Task
Imagine the following scenario, your company is growing quickly 🚀 and increasing the number services being deployed and configured.
It's been noticed that the code in `tf/main.tf` is not very easy to maintain 😢.

The team would like to work on the following problems:

- Improve the terraform code to make it easier to add/update/remove services.
- Add a new environment called `staging` that runs each microservice.
- Structure your code in a way that will segregate environments
- Add a README detailing your design decisions, if you are new to Terraform let us know
- Document in your README how your code would fit into a CI/CD pipeline
- 🚨 The new staging environment should be created when you run `vagrant up` and the apps should print `service started` and print the secret data 🚨

## 📝 Candidate instructions
1. Create a private [GitHub](https://help.github.com/en/articles/create-a-repo) repository
2. Copying all files from this repository into your new private repository
3. Complete the [Task](#task) :tada:
4. [Invite](https://help.github.com/en/articles/inviting-collaborators-to-a-personal-repository) [@form3tech-interviewer-1](https://github.com/form3tech-interviewer-1) to your private repo
5. Let us know you've completed the exercise using the link provided at the bottom of the email from our recruitment team

