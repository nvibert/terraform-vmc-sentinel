provider "vmc" {
  refresh_token = ""
}

data "vmc_org" "my_org" {
  id = ""
}

data "vmc_connected_accounts" "my_accounts" {
  org_id = data.vmc_org.my_org.id
}

data "vmc_customer_subnets" "my_subnets" {
  org_id               = data.vmc_org.my_org.id
  connected_account_id = data.vmc_connected_accounts.my_accounts.ids[2]
  region               = "EU_WEST_2"
}

resource "vmc_sddc" "sddc_1" {
  org_id = data.vmc_org.my_org.id

  # storage_capacity    = 100
  sddc_name           = "my_SDDC_name"
  vpc_cidr            = "10.2.0.0/16"
  num_host            = 1
  provider_type       = "AWS"
  region              = data.vmc_customer_subnets.my_subnets.region
  vxlan_subnet        = "192.168.1.0/24"
  delay_account_link  = false
  skip_creating_vxlan = false
  sso_domain          = "vmc.local"

  # sddc_template_id = ""
  deployment_type = "SingleAZ"
  sddc_type       = "1NODE"
  account_link_sddc_config {
    customer_subnet_ids  = ["my_subnet"]
    connected_account_id = data.vmc_connected_accounts.my_accounts.ids[2]
  }
  timeouts {
    create = "300m"
    update = "300m"
    delete = "180m"
  }
}
