terraform {
  required_version = ">= 1.0.7"

  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.15.0"
    }
    vault = {
      version = "3.0.1"
    }
    git = {
      source  = "innovationnorway/git"
      version = ">= 0.1.3"
    }
  }
}