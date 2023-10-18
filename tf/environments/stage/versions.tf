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
  }
}