variable "vpc_environment" {
  default = "prod"
  
}
variable "vpc_name" {
  default = "prod_vpc"
}

variable "prod_cidr" {
    default = "10.0.0.0/16"
}

variable "vpc_app_subnets" {
  type = map(string)
  default = {ap-northeast-2a = "10.0.1.0/24",
             ap-northeast-2b = "10.0.2.0/24",
             ap-northeast-2c = "10.0.3.0/24"}
}

variable "vpc_data_subnets" {
  type = map(string)
  default = {ap-northeast-2a = "10.0.4.0/24",
             ap-northeast-2b = "10.0.5.0/24",
             ap-northeast-2c = "10.0.6.0/24"}
}

variable "vpc_public_subnets" {
  type = map(string)
  default = {ap-northeast-2a = "10.0.11.0/24",
             ap-northeast-2b = "10.0.12.0/24",
             ap-northeast-2c = "10.0.13.0/24"}
}


variable "db_username" {
  type = string
  sensitive = true
}

variable "db_password" {
  type = string
  sensitive = true
}

variable "prod_ami" {
  default = "ami-083e69acfa4b35b6f"
}

variable "bastion_ami" {
  default = "ami-00dab80918a1fa50d"
}

variable "app_count" {
  default = "2"
}