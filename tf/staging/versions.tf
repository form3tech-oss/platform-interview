terraform {
  required_version = ">= 1.3.2"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }

    vault = {
      version = "3.14.0"
    }
  }
}
