terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "droplet_count" {}
variable "region" {}
variable "name" {}
variable "tags" {}
variable "size" {}
variable "image" {}
variable "ssh_key_name" {}
variable "digital_ocean_project_name" {}
#variable "vpc_uuid" {}

data "digitalocean_ssh_key" "default" {
  name = var.ssh_key_name
}

data "digitalocean_project" "project_name" {
  name = var.digital_ocean_project_name
}

//resource "digitalocean_volume" "volume" {
//  region      = try(var.region,"nyc1")
//  count       = var.droplet_count
//  name        = "volume-${var.testnet_name}-${var.client_type}-${count.index + 1}"
//  size        = 100
//}

resource "digitalocean_droplet" "droplet" {
  count = var.droplet_count
  image = try(var.image, "ubuntu-22-04-x64")
  name = "${var.name}-${count.index + 1}"
  region = try(var.region,"nyc1")

  size = try(var.size,"s-1vcpu-2gb")
  backups = false
  monitoring = false
  ipv6 = false
  resize_disk = true

  tags = concat(var.tags, [var.name])

  ssh_keys = [data.digitalocean_ssh_key.default.fingerprint]
#  vpc_uuid = var.vpc_uuid
//  volume_ids = [element(digitalocean_volume.volume.*.id, count.index)]
}


resource "digitalocean_project_resources" "assign-to-project" {
  project = data.digitalocean_project.project_name.id
  resources = digitalocean_droplet.droplet.*.urn
}
