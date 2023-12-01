variable "vpc_environment" {
  default = "prod"
  
}
variable "region" {
  default = "eu-central-1"
}
variable "vpc_name" {
  default = "dev_vpc"
}

variable "prod_cidr" {
    default = "10.0.0.0/16"
}

variable "vpc_app_subnets" {
  type = map(string)
  default = {eu-central-1a = "10.0.1.0/24",
             eu-central-1b = "10.0.2.0/24",
             eu-central-1c = "10.0.3.0/24"}
}

variable "vpc_data_subnets" {
  type = map(string)
  default = {eu-central-1a = "10.0.4.0/24",
             eu-central-1b = "10.0.5.0/24",
             eu-central-1c = "10.0.6.0/24"}
}

variable "vpc_public_subnets" {
  type = map(string)
  default = {eu-central-1a = "10.0.11.0/24",
             eu-central-1b = "10.0.12.0/24",
             eu-central-1c = "10.0.13.0/24"}
}



variable "prod_ami" {
  default = "ami-083e69acfa4b35b6f"
}

variable "bastion_ami" {
  default = "ami-00dab80918a1fa50d"
}

