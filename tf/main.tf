module "dev" {
  source = "./environments/dev"
  environment_inputs = {}
  services_inputs = {}
}

//module "prod" {
//  source = "./environments/prod"
//  environment_inputs = []
//  services_inputs = []
//}
//
//module "stage" {
//  source = "./environments/stage"
//  environment_inputs = []
//  services_inputs = []
//}