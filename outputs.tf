output "id" {
  description = "Resource ID of the Function App"
  value       = azurerm_linux_function_app.fn.id
}

output "name" {
  description = "Name of the Function App"
  value       = azurerm_linux_function_app.fn.name
}

output "default_hostname" {
  description = "Default hostname of the Function App"
  value       = azurerm_linux_function_app.fn.default_hostname
}

output "principal_id" {
  description = "Principal ID of the Function App's system-assigned managed identity"
  value       = azurerm_linux_function_app.fn.identity[0].principal_id
}

output "function_storage_name" {
  description = "Name of the storage account dedicated to the Function App"
  value       = azurerm_storage_account.fn_storage.name
}
