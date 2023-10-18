terraform {
  required_version = ">= 1.0.7"

  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.25.0"
    }
    vault = {
      version = "3.0.1"
    }
#may use this in the future to pickup environment by the git branch
//    git = {
//      source  = "innovationnorway/git"
//      version = ">= 0.1.3"
//    }
  }
}