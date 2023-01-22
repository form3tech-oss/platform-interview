resource "docker_container" "this" {
  image = var.IMAGE
  name  = var.NAME
  env   = var.ENV_VARS
  logs  = true
  rm    = true

  networks_advanced {
    name = var.NETWORK_NAME
  }

  dynamic "ports" {
    for_each = var.FRONTEND_CONTAINER == true ? [1] : []
    content {

      internal = var.FRONTEND_INTERNAL_PORT
      external = var.FRONTEND_EXTERNAL_PORT
    }
  }

  lifecycle {
    ignore_changes = all
  }
}

