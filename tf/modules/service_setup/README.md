<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.2 |
| <a name="requirement_docker"></a> [docker](#requirement\_docker) | 3.0.2 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | 3.14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_docker"></a> [docker](#provider\_docker) | 3.0.2 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 3.14.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [docker_container.this](https://registry.terraform.io/providers/kreuzwerker/docker/3.0.2/docs/resources/container) | resource |
| [vault_generic_endpoint.this](https://registry.terraform.io/providers/hashicorp/vault/3.14.0/docs/resources/generic_endpoint) | resource |
| [vault_generic_secret.this](https://registry.terraform.io/providers/hashicorp/vault/3.14.0/docs/resources/generic_secret) | resource |
| [vault_policy.this](https://registry.terraform.io/providers/hashicorp/vault/3.14.0/docs/resources/policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | n/a | `string` | n/a | yes |
| <a name="input_db_user"></a> [db\_user](#input\_db\_user) | n/a | `string` | n/a | yes |
| <a name="input_docker_image"></a> [docker\_image](#input\_docker\_image) | n/a | `string` | n/a | yes |
| <a name="input_endpoint_password"></a> [endpoint\_password](#input\_endpoint\_password) | n/a | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_service"></a> [service](#input\_service) | n/a | `string` | n/a | yes |
| <a name="input_vault_addr"></a> [vault\_addr](#input\_vault\_addr) | n/a | `string` | `""` | no |
| <a name="input_vault_username"></a> [vault\_username](#input\_vault\_username) | n/a | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
