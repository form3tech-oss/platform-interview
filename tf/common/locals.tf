locals {
  config_yaml = yamldecode(file("./config.yaml"))
}
