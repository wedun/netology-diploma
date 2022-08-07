terraform {
  backend "remote" {
    organization = "laykomdn"

    workspaces {
      name = "diploma-workspace-stage"
    }
  }

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  cloud_id  = "b1gfmggr757ala32rq97"
  folder_id = "b1g79ptugpleeoj44c6k"
  zone      = "ru-central1-a"
}