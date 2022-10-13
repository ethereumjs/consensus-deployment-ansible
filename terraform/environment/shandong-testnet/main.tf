terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}


terraform {
  backend "s3" {
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    endpoint                    = "https://fra1.digitaloceanspaces.com"
    region                      = "us-east-1"
    bucket                      = "shanghai-testnets"
    key                         = "infrastructure/shandong-testnet/terraform.tfstate"
  }
}


locals {
  ssh_key_name = "parithosh"
  digital_ocean_project_name = "Consensus Infra"
  size = "s-8vcpu-16gb-amd"
  region = "fra1"
  image = "ubuntu-22-04-x64"
  name = "shandong"
  vpc_name="shandong"
  vpc_ip_range="10.169.78.0/24"
  vpc_region = "fra1"
  shared_project_tags = [
                            "Owner:Parithosh",
                        ]

}

resource "digitalocean_vpc" "vpc" {
  name = local.vpc_name
  ip_range = local.vpc_ip_range
  region = local.vpc_region
}


module "shandong_bootnode" {
  droplet_count = 1

  size =  "s-8vcpu-16gb-amd"
  region = local.region
  image = local.image
  name = "shandong-bootnode"
  source = "../../modules/"

  tags = concat(local.shared_project_tags,["execution","ethereumjs","consensus","lodestar","validator","beacon","explorer","bootnode","faucet", "landing_page","reverse_proxy","shandong-testnet"])
  ssh_key_name = local.ssh_key_name
  digital_ocean_project_name = local.digital_ocean_project_name
#  vpc_uuid = digitalocean_vpc.vpc.id
}

module "shandong_ethereumjs" {
  droplet_count = 8

  size =  "s-4vcpu-8gb-amd"
  region = local.region
  image = local.image
  name = "shandong-ethereumjs-lodestar"
  source = "../../modules/"

  tags = concat(local.shared_project_tags,["execution","ethereumjs","consensus","lodestar","validator","beacon","shandong-testnet"])
  ssh_key_name = local.ssh_key_name
  digital_ocean_project_name = local.digital_ocean_project_name
  #  vpc_uuid = digitalocean_vpc.vpc.id
}
