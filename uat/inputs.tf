variable "vpc_environment" {
  default = "uat"
  
}
variable "vpc_name" {
  default = "uat_vpc"
}

variable "uat_cidr" {
    default = "10.2.0.0/16"
}

variable "vpc_app_subnets" {
  type = map(string)
  default = {ap-northeast-2a = "10.2.1.0/24",
             ap-northeast-2b = "10.2.2.0/24",
             ap-northeast-2c = "10.2.3.0/24"}
}

variable "vpc_data_subnets" {
  type = map(string)
  default = {ap-northeast-2a = "10.2.4.0/24",
             ap-northeast-2b = "10.2.5.0/24",
             ap-northeast-2c = "10.2.6.0/24"}
}

variable "vpc_public_subnets" {
  type = map(string)
  default = {ap-northeast-2a = "10.2.11.0/24",
             ap-northeast-2b = "10.2.12.0/24",
             ap-northeast-2c = "10.2.13.0/24"}
}


variable "db_username" {
  type = string
  sensitive = true
}

variable "db_password" {
  type = string
  sensitive = true
}

variable "uat_ami" {
  
}