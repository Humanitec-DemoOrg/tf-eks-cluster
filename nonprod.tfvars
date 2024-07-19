cluster_name   = "nonprod-eks"
env            = "nonprod"
region         = "eu-west-2"
vpc_id         = "vpc-001b1626c134140ca"
domain         = "dev.bobbydevlabs.org"
dev_domain     = "dev.bobbydevlabs.org"
staging_domain = "preprod.bobbydevlabs.org"
prod_domain    = "bobbydevlabs.org"

domain_aliases = ["*.preprod.bobbydevlabs.org", "*.dev.bobbydevlabs.org", "*.bobbydevlabs.org"]