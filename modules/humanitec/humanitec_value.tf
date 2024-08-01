resource "humanitec_value" "app_val1_value" {
  app_id = humanitec_application.newtrack.id

  key         = "my-secret-shared-value"
  description = "app env level value"
  is_secret   = true

  secret_ref = {
    store = humanitec_secretstore.my_awssm.id
    ref   = "my-secret-shared-value"
  }
}