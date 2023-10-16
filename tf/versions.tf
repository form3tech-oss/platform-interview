terraform {
  required_version = ">= 1.0.7"

  required_providers {
    vault = {
      version = "3.0.1"
    }
    git = {
      source  = "innovationnorway/git"
      version = ">= 0.1.3"
    }
  }
}