resource "humanitec_resource_definition" "agent" {
  id   = "bobby-dvo01-${var.environment}"
  name = "Bobby Agent"
  type = "agent"

  driver_type    = "humanitec/agent"
  driver_account = humanitec_resource_account.cloud_account.id
  driver_inputs = {
    values_string = jsonencode({
      id = "bobby-dvo01-${var.environment}"
    })
  }
}

resource "humanitec_agent" "agent" {
  id          = humanitec_resource_definition.agent.id
  description = "Bobby Agent"
  public_keys = [
    {
      key = file("humanitec_operator_agent_public_key.pem")
    }
  ]
}

resource "humanitec_resource_definition_criteria" "dev_agent" {
  resource_definition_id = humanitec_agent.agent.id
  env_type               = "development"
  depends_on             = [humanitec_agent.agent]
}

resource "humanitec_resource_definition_criteria" "staging_agent" {
  resource_definition_id = humanitec_agent.agent.id
  env_type               = "staging"
  depends_on             = [humanitec_agent.agent]
}

resource "humanitec_resource_definition_criteria" "prod_agent" {
  resource_definition_id = humanitec_agent.agent.id
  env_type               = "production"
  depends_on             = [humanitec_agent.agent]
}