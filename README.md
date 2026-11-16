# Terraform Azure AVM OpenAI Module

This module is an **Azure Verified Module (AVM) Wrapper** for deploying Azure OpenAI and other Cognitive Services accounts. It provides a simplified interface for the official Microsoft AVM module and can be integrated into Azure landing zone deployments.

## Features

- **Multi-Kind Support**: Deploy OpenAI, FormRecognizer, AIServices, and more than 30 other cognitive kinds.
- **Security**: Support for Managed Identities, Customer Managed Keys (CMK) with HSM support, and Role Based Access Control (RBAC).
- **Networking**: Private Endpoint support and network rulesets (Firewall).
- **Model Deployment**: Configure `cognitive_deployments` to manage models like `gpt-4o-mini` directly.
- **RAI Policies**: Integrated support for Responsible AI (RAI) policies and content filters.
- **Observability**: Integrated Diagnostic Settings and Telemetry tracking.

## Folder Structure

The module follows the standard Azure Verified Module (AVM) layout:

- `.config/`: AVM configuration metadata.
- `.github/`: CI/CD workflows for validation.
- `examples/`: Comprehensive usage scenarios.
- `main.tf`: Core logic wrapping the official AVM module.
- `variables.tf`: Input variable definitions matching official standards.
- `outputs.tf`: Module outputs.
- `CHANGELOG`: Version history and updates.

## Testing and Verification

To verify that this module works correctly, you can use the provided examples in the `examples/` folder.

### 1. Manual Validation

Run the following commands inside the module root to validate the code:

```bash
terraform init -backend=false
terraform validate
```

### 2. Integration Test (Plan)

To see what resources will be created without actually deploying them:

```bash
cd examples/default
# Set your Azure subscription (required)
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
terraform init
terraform plan
```

### 3. Full Deployment Test

If you have a testing environment, you can deploy any of the examples:

```bash
cd examples/default
terraform apply -auto-approve
# After verification, destroy the resources
terraform destroy -auto-approve
```

## Usage

```hcl
module "openai" {
  source = "git::https://github.com/sebas80sebas/terraform-azure-avm-openai.git"

  name      = "my-openai-account"
  parent_id = "/subscriptions/.../resourceGroups/my-rg"
  location  = "eastus"
  kind      = "OpenAI"
  sku_name  = "S0"

  cognitive_deployments = {
    "gpt-4o-mini" = {
      name = "gpt-4o-mini"
      model = {
        format  = "OpenAI"
        name    = "gpt-4o-mini"
        version = "2024-07-18"
      }
      scale = {
        type = "Standard"
      }
    }
  }

  tags = {
    environment = "prod"
  }
}
```

## Examples

- [Azure OpenAI Service](./examples/default): Default deployment with an OpenAI model deployment.
- [Azure AI Service](./examples/Azure-AI-Service): Deployment of generic Cognitive Services (e.g., TextAnalytics).
- [Azure AI Foundry Classic](./examples/Azure-AI-Foundry-Classic): Deployment of an AI Foundry Hub and Project using the classic Cognitive Services model.
- [Azure AI Document Intelligence](./examples/Azure-AI-Document-Intelligence): Deployment of FormRecognizer.
- [Customer Managed Key Encryption](./examples/Azure-OpenAI-with-customer_managed_key_encryption): OpenAI protected by a Key Vault CMK.ey encryption.
- [Private Endpoint](./examples/Azure-OpenAI-with-private-endpoint): Deployment within a VNET using Private Link.
- [RAI Policy](./examples/rai_policy): Configuring Responsible AI policies and content filters.
- [Local Auth Disabled](./examples/Azure-OpenAI-with-local-auth-disabled): Testing security posture with local authentication disabled.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9, < 2.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 2.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.17.0, < 5.0 |
| <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) | ~> 0.3 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | 2.8.0 |
| <a name="provider_modtm"></a> [modtm](#provider\_modtm) | 0.3.5 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.8.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_openai"></a> [openai](#module\_openai) | Azure/avm-res-cognitiveservices-account/azurerm | 0.11.0 |

## Resources

| Name | Type |
|------|------|
| [modtm_telemetry.telemetry](https://registry.terraform.io/providers/azure/modtm/latest/docs/resources/telemetry) | resource |
| [random_uuid.telemetry](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [azapi_client_config.telemetry](https://registry.terraform.io/providers/Azure/azapi/latest/docs/data-sources/client_config) | data source |
| [modtm_module_source.telemetry](https://registry.terraform.io/providers/azure/modtm/latest/docs/data-sources/module_source) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_project_management"></a> [allow\_project\_management](#input\_allow\_project\_management) | Specifies whether this resource support project management as child resources, used as containers for access management, data isolation and cost in AI Foundry. | `bool` | `false` | no |
| <a name="input_aml_workspace"></a> [aml\_workspace](#input\_aml\_workspace) | Details of the connection to an Azure Machine Learning workspace. | <pre>object({<br/>    resource_id        = string<br/>    identity_client_id = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_associated_projects"></a> [associated\_projects](#input\_associated\_projects) | List of associated project IDs. | `list(string)` | `[]` | no |
| <a name="input_cognitive_deployments"></a> [cognitive\_deployments](#input\_cognitive\_deployments) | Map of deployments (models) for the Cognitive Services account. | <pre>map(object({<br/>    name                       = string<br/>    rai_policy_name            = optional(string)<br/>    version_upgrade_option     = optional(string, "OnceNewDefaultVersionAvailable")<br/>    dynamic_throttling_enabled = optional(bool, false)<br/>    model = object({<br/>      format  = string<br/>      name    = string<br/>      version = optional(string)<br/>    })<br/>    scale = object({<br/>      capacity = optional(number, 1)<br/>      family   = optional(string)<br/>      size     = optional(string)<br/>      tier     = optional(string)<br/>      type     = string<br/>    })<br/>    retry = optional(object({<br/>      error_message_regex  = list(string)<br/>      interval_seconds     = optional(number, 30)<br/>      max_interval_seconds = optional(number, 300)<br/>      multiplier           = optional(number, 1.5)<br/>      randomization_factor = optional(number, 0.3)<br/>    }))<br/>    timeouts = optional(object({<br/>      create = optional(string)<br/>      delete = optional(string)<br/>      read   = optional(string)<br/>      update = optional(string)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_custom_question_answering_search_service_id"></a> [custom\_question\_answering\_search\_service\_id](#input\_custom\_question\_answering\_search\_service\_id) | The ID of the search service if the kind is TextAnalytics. | `string` | `null` | no |
| <a name="input_custom_question_answering_search_service_key"></a> [custom\_question\_answering\_search\_service\_key](#input\_custom\_question\_answering\_search\_service\_key) | The key of the search service for QnA. | `string` | `null` | no |
| <a name="input_custom_subdomain_name"></a> [custom\_subdomain\_name](#input\_custom\_subdomain\_name) | Custom subdomain name for the resource. | `string` | `null` | no |
| <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key) | Configuration for customer-managed keys (CMK). | <pre>object({<br/>    key_vault_resource_id = string<br/>    key_name              = string<br/>    key_version           = optional(string, null)<br/>    user_assigned_identity = optional(object({<br/>      resource_id = string<br/>    }), null)<br/>  })</pre> | `null` | no |
| <a name="input_default_project"></a> [default\_project](#input\_default\_project) | Default project for the account. | `string` | `null` | no |
| <a name="input_deployment_serialization_enabled"></a> [deployment\_serialization\_enabled](#input\_deployment\_serialization\_enabled) | Enables serialization in deployments. | `bool` | `true` | no |
| <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings) | Diagnostic settings configuration for sending logs and metrics. | <pre>map(object({<br/>    name                                     = optional(string, null)<br/>    log_categories                           = optional(set(string), [])<br/>    log_groups                               = optional(set(string), ["allLogs"])<br/>    metric_categories                        = optional(set(string), ["AllMetrics"])<br/>    log_analytics_destination_type           = optional(string, "Dedicated")<br/>    workspace_resource_id                    = optional(string, null)<br/>    storage_account_resource_id              = optional(string, null)<br/>    event_hub_authorization_rule_resource_id = optional(string, null)<br/>    event_hub_name                           = optional(string, null)<br/>    marketplace_partner_resource_id          = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_dynamic_throttling_enabled"></a> [dynamic\_throttling\_enabled](#input\_dynamic\_throttling\_enabled) | Specifies whether dynamic throttling is enabled. | `bool` | `false` | no |
| <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry) | Controls whether or not telemetry is enabled for the module. | `bool` | `true` | no |
| <a name="input_fqdns"></a> [fqdns](#input\_fqdns) | List of fully qualified domain names. | `list(string)` | `[]` | no |
| <a name="input_is_hsm_key"></a> [is\_hsm\_key](#input\_is\_hsm\_key) | Is the customer managed key an HSM key? | `bool` | `false` | no |
| <a name="input_kind"></a> [kind](#input\_kind) | Specifies the type of Cognitive Service Account (e.g., OpenAI, ComputerVision, TextAnalytics). | `string` | n/a | yes |
| <a name="input_local_auth_enabled"></a> [local\_auth\_enabled](#input\_local\_auth\_enabled) | Specifies whether local authentication (keys) is allowed. | `bool` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where the resource should be created. | `string` | n/a | yes |
| <a name="input_lock"></a> [lock](#input\_lock) | Resource lock configuration (CanNotDelete/ReadOnly). | <pre>object({<br/>    kind = string<br/>    name = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_managed_identities"></a> [managed\_identities](#input\_managed\_identities) | Managed Identities configuration (System/User assigned). | <pre>object({<br/>    system_assigned            = optional(bool, false)<br/>    user_assigned_resource_ids = optional(set(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_metrics_advisor_aad_client_id"></a> [metrics\_advisor\_aad\_client\_id](#input\_metrics\_advisor\_aad\_client\_id) | AAD Client ID for Metrics Advisor. | `string` | `null` | no |
| <a name="input_metrics_advisor_aad_tenant_id"></a> [metrics\_advisor\_aad\_tenant\_id](#input\_metrics\_advisor\_aad\_tenant\_id) | AAD Tenant ID for Metrics Advisor. | `string` | `null` | no |
| <a name="input_metrics_advisor_super_user_name"></a> [metrics\_advisor\_super\_user\_name](#input\_metrics\_advisor\_super\_user\_name) | Super user name for Metrics Advisor. | `string` | `null` | no |
| <a name="input_metrics_advisor_website_name"></a> [metrics\_advisor\_website\_name](#input\_metrics\_advisor\_website\_name) | Website name for Metrics Advisor. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Cognitive Service Account. | `string` | n/a | yes |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | Network ACLs configuration (firewall, virtual networks). | <pre>object({<br/>    default_action = string<br/>    ip_rules       = optional(set(string))<br/>    virtual_network_rules = optional(set(object({<br/>      ignore_missing_vnet_service_endpoint = optional(bool)<br/>      subnet_id                            = string<br/>    })))<br/>    bypass = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_network_injections"></a> [network\_injections](#input\_network\_injections) | Network injection configuration. | <pre>object({<br/>    subnet_id                         = string<br/>    scenario                          = string<br/>    microsoft_managed_network_enabled = optional(bool, false)<br/>  })</pre> | `null` | no |
| <a name="input_outbound_network_access_restricted"></a> [outbound\_network\_access\_restricted](#input\_outbound\_network\_access\_restricted) | Restricts outbound network access. | `bool` | `null` | no |
| <a name="input_parent_id"></a> [parent\_id](#input\_parent\_id) | The resource ID of the Resource Group where the service will be hosted. | `string` | n/a | yes |
| <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints) | Private Endpoints configuration for the resource. | <pre>map(object({<br/>    name = optional(string, null)<br/>    role_assignments = optional(map(object({<br/>      role_definition_id_or_name             = string<br/>      principal_id                           = string<br/>      description                            = optional(string, null)<br/>      skip_service_principal_aad_check       = optional(bool, false)<br/>      condition                              = optional(string, null)<br/>      condition_version                      = optional(string, null)<br/>      delegated_managed_identity_resource_id = optional(string, null)<br/>      principal_type                         = optional(string, null)<br/>    })), {})<br/>    lock = optional(object({<br/>      kind = string<br/>      name = optional(string, null)<br/>    }), null)<br/>    tags                                    = optional(map(string), null)<br/>    subnet_resource_id                      = string<br/>    private_dns_zone_group_name             = optional(string, "default")<br/>    private_dns_zone_resource_ids           = optional(set(string), [])<br/>    application_security_group_associations = optional(map(string), {})<br/>    private_service_connection_name         = optional(string, null)<br/>    network_interface_name                  = optional(string, null)<br/>    location                                = optional(string, null)<br/>    resource_group_name                     = optional(string, null)<br/>    ip_configurations = optional(map(object({<br/>      name               = string<br/>      private_ip_address = string<br/>    })), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_private_endpoints_manage_dns_zone_group"></a> [private\_endpoints\_manage\_dns\_zone\_group](#input\_private\_endpoints\_manage\_dns\_zone\_group) | Manages the DNS zone group for Private Endpoints. | `bool` | `true` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Enables or blocks access from public networks. | `bool` | `true` | no |
| <a name="input_qna_runtime_endpoint"></a> [qna\_runtime\_endpoint](#input\_qna\_runtime\_endpoint) | Runtime endpoint for QnA. | `string` | `null` | no |
| <a name="input_rai_monitor_config"></a> [rai\_monitor\_config](#input\_rai\_monitor\_config) | Controls the Rai Monitor configuration on this resource. | <pre>object({<br/>    adx_storage_resource_id = string<br/>    identity_client_id      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_rai_policies"></a> [rai\_policies](#input\_rai\_policies) | Map of RAI policies to create. | <pre>map(object({<br/>    name             = string<br/>    base_policy_name = string<br/>    mode             = string<br/>    content_filters = optional(list(object({<br/>      blocking           = bool<br/>      enabled            = bool<br/>      name               = string<br/>      severity_threshold = string<br/>      source             = string<br/>    })))<br/>    custom_block_lists = optional(list(object({<br/>      source          = string<br/>      block_list_name = string<br/>      blocking        = bool<br/>    })))<br/>  }))</pre> | `{}` | no |
| <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments) | Map of RBAC role assignments to apply. | <pre>map(object({<br/>    role_definition_id_or_name             = string<br/>    principal_id                           = string<br/>    description                            = optional(string, null)<br/>    skip_service_principal_aad_check       = optional(bool, false)<br/>    condition                              = optional(string, null)<br/>    condition_version                      = optional(string, null)<br/>    delegated_managed_identity_resource_id = optional(string, null)<br/>    principal_type                         = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU name for the account (e.g., S0). | `string` | n/a | yes |
| <a name="input_storage"></a> [storage](#input\_storage) | Configuration of linked storage accounts. | <pre>list(object({<br/>    identity_client_id = optional(string)<br/>    storage_account_id = string<br/>  }))</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to organize the resource. | `map(string)` | `null` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Custom timeouts for CRUD operations. | <pre>object({<br/>    create = optional(string)<br/>    delete = optional(string)<br/>    read   = optional(string)<br/>    update = optional(string)<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The endpoint used to connect to the Cognitive Service Account. |
| <a name="output_name"></a> [name](#output\_name) | The name of cognitive account created. |
| <a name="output_primary_access_key"></a> [primary\_access\_key](#output\_primary\_access\_key) | A primary access key which can be used to connect to the Cognitive Service Account. This will be null when `var.local_auth_enabled` is set to false. |
| <a name="output_private_endpoints"></a> [private\_endpoints](#output\_private\_endpoints) | A map of the private endpoints created. |
| <a name="output_rai_policy_id"></a> [rai\_policy\_id](#output\_rai\_policy\_id) | The ID of the RAI policy created. |
| <a name="output_resource"></a> [resource](#output\_resource) | The cognitive account resource created in AzureRM schema. |
| <a name="output_resource_cognitive_deployment"></a> [resource\_cognitive\_deployment](#output\_resource\_cognitive\_deployment) | The map of cognitive deployments created in AzureRM schema. |
| <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id) | The resource ID of cognitive account created. |
| <a name="output_resource_sensitive"></a> [resource\_sensitive](#output\_resource\_sensitive) | The cognitive account resource created, sensitive data only. |
| <a name="output_secondary_access_key"></a> [secondary\_access\_key](#output\_secondary\_access\_key) | A secondary access key which can be used to connect to the Cognitive Service Account. This will be null when `local_auth_enabled` is set to false. |
| <a name="output_system_assigned_mi_principal_id"></a> [system\_assigned\_mi\_principal\_id](#output\_system\_assigned\_mi\_principal\_id) | The principal ID of system assigned managed identity on the Cognitive/AI Service account created, when `var.managed_identities` is `null` or `var.managed_identities.system_assigned` is `false` this output is `null`. |
<!-- END_TF_DOCS -->
