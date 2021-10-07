# platform-interview
Form3 Platform Interview


## Running the sample application
- make sure you have [vagrant](https://www.vagrantup.com/downloads) installed
- `vagrant up`


## Test

3 application
- each application username/password auth
   - policy to access that application
- secrets space by convention `secrets/{name of application}`


## Task
Company is scaling and increasing number services, it's been highlight that this IAC is not very maintainable...

- Please refactor to make it easy to add/update/remove services
- Add a new environment `staging` that runs each microservice

> Note: Installation of vault instances found in `Vagrantfile` should be considered to be managed outside of this solution. 


````

```