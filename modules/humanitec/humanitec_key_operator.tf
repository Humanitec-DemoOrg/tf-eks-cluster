resource "humanitec_key" "operator" {
  key = file("humanitec_operator_agent_public_key.pem")
}