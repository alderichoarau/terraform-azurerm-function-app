# terraform-azurerm-function-app

Terraform module that provisions an Azure Linux Function App (Python) with its own dedicated storage
account on an existing App Service Plan.

The module does not create or manage the App Service Plan — pass an existing `service_plan_id`
(shared or dedicated).

## Usage

```hcl
module "function_app" {
  source  = "app.terraform.io/alderic-hoarau/function-app/azurerm"
  version = "~> 0.1"

  name                  = "fn-my-project"
  storage_account_name  = "stfnmyproject"
  resource_group_name   = azurerm_resource_group.this.name
  location              = azurerm_resource_group.this.location
  service_plan_id       = azurerm_service_plan.this.id

  tags = {
    owner = "my-team"
  }
}
```

See [examples/basic](examples/basic) for a complete, runnable example.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.9 |
| azurerm | ~> 4.0 |

## Providers

| Name | Version |
| ---- | ------- |
| azurerm | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_linux_function_app.fn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app) | resource |
| [azurerm_role_assignment.fn_storage_blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.fn_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| location | Azure region for the Function App and its dedicated storage account | `string` | n/a | yes |
| name | Name of the Linux Function App | `string` | n/a | yes |
| python\_version | Python runtime version for the Function App stack | `string` | `"3.11"` | no |
| resource\_group\_name | Name of the Resource Group to deploy into | `string` | n/a | yes |
| service\_plan\_id | ID of the (shared or dedicated) App Service Plan the Function App runs on | `string` | n/a | yes |
| storage\_account\_name | Name of the storage account dedicated to the Function App (lowercase letters and digits only, 3-24 chars) | `string` | n/a | yes |
| tags | Tags applied to all resources in this module | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| default\_hostname | Default hostname of the Function App |
| function\_storage\_name | Name of the storage account dedicated to the Function App |
| id | Resource ID of the Function App |
| name | Name of the Function App |
| principal\_id | Principal ID of the Function App's system-assigned managed identity |
<!-- END_TF_DOCS -->

## Notes

- The dedicated storage account has `shared_access_key_enabled = false`; the Function App connects to it
  via its system-assigned managed identity (`storage_uses_managed_identity = true`), granted
  `Storage Blob Data Owner` on that account.
- `https_only = true` is enforced unconditionally.

## Local Git hooks

A [`.pre-commit-config.yaml`](.pre-commit-config.yaml) runs `terraform fmt`, `terraform validate`,
`tflint` and `terraform-docs` before each commit. One-time setup:

```bash
pip install pre-commit   # or: brew install pre-commit
pre-commit install
```

## Contributing

This repository does not accept external contributions. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

All rights reserved. See [LICENSE](LICENSE).
