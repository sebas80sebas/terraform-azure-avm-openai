variable "kind" {
  type        = string
  description = "Specifies the type of Cognitive Service Account (e.g., OpenAI, ComputerVision, TextAnalytics)."
}

variable "location" {
  type        = string
  description = "The Azure region where the resource should be created."
}

variable "name" {
  type        = string
  description = "The name of the Cognitive Service Account."
}

variable "parent_id" {
  type        = string
  description = "The resource ID of the Resource Group where the service will be hosted."
}

variable "sku_name" {
  type        = string
  description = "The SKU name for the account (e.g., S0)."
}

# Optional Variables

variable "allow_project_management" {
  type        = bool
  default     = false
  description = "Specifies whether this resource support project management as child resources, used as containers for access management, data isolation and cost in AI Foundry."
}

variable "aml_workspace" {
  type = object({
    resource_id        = string
    identity_client_id = optional(string, null)
  })
  default     = null
  description = "Details of the connection to an Azure Machine Learning workspace."
}

variable "associated_projects" {
  type        = list(string)
  default     = []
  description = "List of associated project IDs."
}

variable "cognitive_deployments" {
  type = map(object({
    name                       = string
    rai_policy_name            = optional(string)
    version_upgrade_option     = optional(string, "OnceNewDefaultVersionAvailable")
    dynamic_throttling_enabled = optional(bool, false)
    model = object({
      format  = string
      name    = string
      version = optional(string)
    })
    scale = object({
      capacity = optional(number, 1)
      family   = optional(string)
      size     = optional(string)
      tier     = optional(string)
      type     = string
    })
    retry = optional(object({
      error_message_regex  = list(string)
      interval_seconds     = optional(number, 30)
      max_interval_seconds = optional(number, 300)
      multiplier           = optional(number, 1.5)
      randomization_factor = optional(number, 0.3)
    }))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      read   = optional(string)
      update = optional(string)
    }))
  }))
  default     = {}
  description = "Map of deployments (models) for the Cognitive Services account."
}

variable "custom_question_answering_search_service_id" {
  type        = string
  default     = null
  description = "The ID of the search service if the kind is TextAnalytics."
}

variable "custom_question_answering_search_service_key" {
  type        = string
  default     = null
  description = "The key of the search service for QnA."
}

variable "custom_subdomain_name" {
  type        = string
  default     = null
  description = "Custom subdomain name for the resource."
}

variable "customer_managed_key" {
  type = object({
    key_vault_resource_id = string
    key_name              = string
    key_version           = optional(string, null)
    user_assigned_identity = optional(object({
      resource_id = string
    }), null)
  })
  default     = null
  description = "Configuration for customer-managed keys (CMK)."
}

variable "default_project" {
  type        = string
  default     = null
  description = "Default project for the account."
}

variable "deployment_serialization_enabled" {
  type        = bool
  default     = true
  description = "Enables serialization in deployments."
}

variable "diagnostic_settings" {
  type = map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
  default     = {}
  description = "Diagnostic settings configuration for sending logs and metrics."
}

variable "dynamic_throttling_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether dynamic throttling is enabled."
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = "Controls whether or not telemetry is enabled for the module."
}

variable "fqdns" {
  type        = list(string)
  default     = []
  description = "List of fully qualified domain names."
}

variable "is_hsm_key" {
  type        = bool
  default     = false
  description = "Is the customer managed key an HSM key?"
}

variable "local_auth_enabled" {
  type        = bool
  default     = null
  description = "Specifies whether local authentication (keys) is allowed."
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = "Resource lock configuration (CanNotDelete/ReadOnly)."
}

variable "managed_identities" {
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default     = {}
  description = "Managed Identities configuration (System/User assigned)."
}

variable "metrics_advisor_aad_client_id" {
  type        = string
  default     = null
  description = "AAD Client ID for Metrics Advisor."
}

variable "metrics_advisor_aad_tenant_id" {
  type        = string
  default     = null
  description = "AAD Tenant ID for Metrics Advisor."
}

variable "metrics_advisor_super_user_name" {
  type        = string
  default     = null
  description = "Super user name for Metrics Advisor."
}

variable "metrics_advisor_website_name" {
  type        = string
  default     = null
  description = "Website name for Metrics Advisor."
}

variable "network_acls" {
  type = object({
    default_action = string
    ip_rules       = optional(set(string))
    virtual_network_rules = optional(set(object({
      ignore_missing_vnet_service_endpoint = optional(bool)
      subnet_id                            = string
    })))
    bypass = optional(string)
  })
  default     = null
  description = "Network ACLs configuration (firewall, virtual networks)."
}

variable "network_injections" {
  type = object({
    subnet_id                         = string
    scenario                          = string
    microsoft_managed_network_enabled = optional(bool, false)
  })
  default     = null
  description = "Network injection configuration."
}

variable "outbound_network_access_restricted" {
  type        = bool
  default     = null
  description = "Restricts outbound network access."
}

variable "private_endpoints" {
  type = map(object({
    name = optional(string, null)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })), {})
    lock = optional(object({
      kind = string
      name = optional(string, null)
    }), null)
    tags                                    = optional(map(string), null)
    subnet_resource_id                      = string
    private_dns_zone_group_name             = optional(string, "default")
    private_dns_zone_resource_ids           = optional(set(string), [])
    application_security_group_associations = optional(map(string), {})
    private_service_connection_name         = optional(string, null)
    network_interface_name                  = optional(string, null)
    location                                = optional(string, null)
    resource_group_name                     = optional(string, null)
    ip_configurations = optional(map(object({
      name               = string
      private_ip_address = string
    })), {})
  }))
  default     = {}
  description = "Private Endpoints configuration for the resource."
}

variable "private_endpoints_manage_dns_zone_group" {
  type        = bool
  default     = true
  description = "Manages the DNS zone group for Private Endpoints."
}

variable "public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Enables or blocks access from public networks."
}

variable "qna_runtime_endpoint" {
  type        = string
  default     = null
  description = "Runtime endpoint for QnA."
}

variable "rai_monitor_config" {
  type = object({
    adx_storage_resource_id = string
    identity_client_id      = optional(string, null)
  })
  default     = null
  description = "Controls the Rai Monitor configuration on this resource."
}

variable "rai_policies" {
  type = map(object({
    name             = string
    base_policy_name = string
    mode             = string
    content_filters = optional(list(object({
      blocking           = bool
      enabled            = bool
      name               = string
      severity_threshold = string
      source             = string
    })))
    custom_block_lists = optional(list(object({
      source          = string
      block_list_name = string
      blocking        = bool
    })))
  }))
  default     = {}
  description = "Map of RAI policies to create."
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
  default     = {}
  description = "Map of RBAC role assignments to apply."
}

variable "storage" {
  type = list(object({
    identity_client_id = optional(string)
    storage_account_id = string
  }))
  default     = null
  description = "Configuration of linked storage accounts."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags to organize the resource."
}

variable "timeouts" {
  type = object({
    create = optional(string)
    delete = optional(string)
    read   = optional(string)
    update = optional(string)
  })
  default     = null
  description = "Custom timeouts for CRUD operations."
}
