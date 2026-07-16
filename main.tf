# Storage dedicated to the Function App (required, separate from any business storage)
resource "azurerm_storage_account" "fn_storage" {
  # checkov:skip=CKV_AZURE_59: public access disabled via allow_nested_items_to_be_public (azurerm 4.x)
  # checkov:skip=CKV2_AZURE_1: CMK requires Azure Key Vault, out of scope for this module
  # checkov:skip=CKV_AZURE_206: GRS replication left to the caller; LRS is the module default
  # checkov:skip=CKV_AZURE_33: queue logging not required by callers of this module
  # checkov:skip=CKV2_AZURE_33: private endpoint requires VNet integration, out of scope for this module
  # checkov:skip=CKV2_AZURE_41: SAS expiration policy left to the caller
  # checkov:skip=CKV2_AZURE_21: blob read logging not required by callers of this module
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  tags = merge(var.tags, { purpose = "function-storage" })
}

resource "azurerm_linux_function_app" "fn" {
  # checkov:skip=CKV_AZURE_221: public network access required by callers of this module
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  service_plan_id               = var.service_plan_id
  storage_account_name          = azurerm_storage_account.fn_storage.name
  storage_uses_managed_identity = true
  https_only                    = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      python_version = var.python_version
    }
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "fn_storage_blob" {
  scope                = azurerm_storage_account.fn_storage.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_linux_function_app.fn.identity[0].principal_id
}
