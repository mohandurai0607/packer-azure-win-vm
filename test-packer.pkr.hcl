packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "2.1.7"
    }
  }
}

# Authentication

variable "use_azure_cli_auth" {
  type    = bool
  default = true
}

variable "destination_image_gallery_subscription" {
  type    = string
  default = null
}

variable "destination_image_gallery_rg" {
  type    = string
  default = "packer-poc" #need to create before apply
}

variable "destination_image_gallery" {
  type    = string
  default = "POCSpecGallery" #need to create before apply
}

variable "destination_image" {
  type    = string
  default = "test-image" #need to create before apply
}

variable "destination_image_version" {
  type    = string
  default = "1.0.0"
}

variable "os_type" {
  type    = string
  default = "Windows"
}

variable "image_publisher" {
  type    = string
  default = "MicrosoftWindowsServer"
}

variable "image_offer" {
  type    = string
  default = "WindowsServer"
}

variable "image_sku" {
  type    = string
  default = "2022-datacenter-g2"
}

variable "winrm_timeout" {
  type    = string
  default = "3h"
}

variable "location" {
  type    = string
  default = "Central India"
}

variable "vm_size" {
  type    = string
  default = "Standard_B2s"
}
variable "specialized" {
  type    = bool
  default = true
}

# Build Conf
source "azure-arm" "image" {
  use_azure_cli_auth = var.use_azure_cli_auth
  vm_size            = var.vm_size
  location           = var.location

  os_type         = var.os_type
  image_publisher = var.image_publisher
  image_offer     = var.image_offer
  image_sku       = var.image_sku

  managed_image_name                = "${var.destination_image}-${var.destination_image_version}"
  managed_image_resource_group_name = var.destination_image_gallery_rg

  shared_image_gallery_destination {
    subscription        = var.destination_image_gallery_subscription
    resource_group      = var.destination_image_gallery_rg
    gallery_name        = var.destination_image_gallery
    image_name          = var.destination_image
    image_version       = var.destination_image_version
    replication_regions = [var.location]
    #specialized         = var.specialized
  }

  communicator   = "winrm"
  winrm_use_ssl  = true
  winrm_insecure = true
  winrm_timeout  = var.winrm_timeout
  winrm_username = "packer"
}

build {
  sources = ["azure-arm.image"]

  provisioner "powershell" {
    script = "script.ps1"
  }

  provisioner "powershell" {
    script = "sysprep.ps1"
  }
}


# Stepes to Build the Gen Images

# 1. packer init .   
# 2. packer fmt .   
# 3. packer validate .
# 4. packer build ./test-packer.pkr.hcl