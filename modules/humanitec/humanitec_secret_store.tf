resource "humanitec_secretstore" "my_awssm" {
  id      = var.secret_store_name
  primary = true
  awssm = {
    region = var.region
  }
}

