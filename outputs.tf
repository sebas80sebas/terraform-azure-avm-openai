output "endpoint" {
  description = "The endpoint used to connect to the Cognitive Service Account."
  value       = module.openai.endpoint
}

output "name" {
  description = "The name of cognitive account created."
  value       = module.openai.name
}

output "primary_access_key" {
  description = "A primary access key which can be used to connect to the Cognitive Service Account. This will be null when `var.local_auth_enabled` is set to false."
  sensitive   = true
  value       = module.openai.primary_access_key
}

output "private_endpoints" {
  description = "A map of the private endpoints created."
  value       = module.openai.private_endpoints
}

output "rai_policy_id" {
  description = "The ID of the RAI policy created."
  value       = module.openai.rai_policy_id
}

output "resource" {
  description = "The cognitive account resource created in AzureRM schema."
  value       = module.openai.resource
}

output "resource_cognitive_deployment" {
  description = "The map of cognitive deployments created in AzureRM schema."
  value       = module.openai.resource_cognitive_deployment
}

output "resource_id" {
  description = "The resource ID of cognitive account created."
  value       = module.openai.resource_id
}

output "resource_sensitive" {
  description = "The cognitive account resource created, sensitive data only."
  sensitive   = true
  value       = module.openai.resource_sensitive
}

output "secondary_access_key" {
  description = "A secondary access key which can be used to connect to the Cognitive Service Account. This will be null when `local_auth_enabled` is set to false."
  sensitive   = true
  value       = module.openai.secondary_access_key
}

output "system_assigned_mi_principal_id" {
  description = "The principal ID of system assigned managed identity on the Cognitive/AI Service account created, when `var.managed_identities` is `null` or `var.managed_identities.system_assigned` is `false` this output is `null`."
  value       = module.openai.system_assigned_mi_principal_id
}
