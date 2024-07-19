resource "humanitec_resource_definition" "agent" {
  id   = "bobby-dvo01-${local.environment}"
  name = "Bobby Agent"
  type = "agent"

  driver_type    = "humanitec/agent"
  driver_account = "humanitec-cloud-account-${local.environment}"
  driver_inputs = {
    values_string = jsonencode({
      id = "bobby-dvo01-${local.environment}"
    })
  }
}

resource "humanitec_agent" "agent" {
  id          = humanitec_resource_definition.agent.id
  description = "Bobby Agent"
  public_keys = [
    {
      key = "-----BEGIN PUBLIC KEY-----\nMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAtuVuTNGW+UqCLSsGL0Yb\n7OGC0lWN7z2nbllEKO67V2qhzj8p3JSQ+MHWj25sdQZbkkt5q69Yqw+Doo33YRga\nUlCbVa0xnXbcC3K97DP2fm9fn6IAecN+J+c0D6K3Gibf5Hps9455X6TALGSifbuC\nsioJiI2aPi1Wb2mHM5JFhDL3HrYiQJjaTXX8ju9wEA7srCHX2Yd+KoJR485ZZDz1\nMwpf403mtsFs/VxjqIYs/6h4YhBExqdjNWskWhbCKDNRGzpRuAGICnUID9ZZU1U5\nGGsCGcAuYhcl+XmviRLkPwAP0SCBD6QHucJopZ5leZ9PAaJxlumklenCaDVM3mom\ntzLlNNfWl37F10PJR7pQRCvCnlKqLYdL/gqGiDKM2KWYkEp0rcPkC1GLAUU2aZNC\nGwbrQVf700yJR8ZhFifQwlv1mz+W4OTRsBEaP4xhBNY3t4QuJYZr+UjhVsiVL+gj\nS09E7WBtOFBt61dGYYvIlhYEP5Qkkh1IX6kd7Autxh6BYgH+fYHfU3FK2GVrEvGu\n5uJS9wXTEUo0BdEkUV/l7eTImqPP5LFH69VOhgEemHKUx72DiPFOP1c0MsmXaC2A\nwbZcS4KjBxrADcFzoW06FQ9sloDZ1Gx8cT/GQWt1/uit/0C2f1rfCatPnIuff9cj\nBDBdr7coFsxoT2xy0Yq1pTcCAwEAAQ==\n-----END PUBLIC KEY-----\n"
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