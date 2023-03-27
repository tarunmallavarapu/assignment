variable "vpc_environment" {
  default = "stage"
  
}
variable "vpc_name" {
  default = "stage_vpc"
}

variable "stage_cidr" {
    default = "10.1.0.0/16"
}

variable "vpc_app_subnets" {
  type = map(string)
  default = {ap-northeast-2a = "10.1.1.0/24",
             ap-northeast-2b = "10.1.2.0/24",
             ap-northeast-2c = "10.1.3.0/24"}
}

variable "vpc_data_subnets" {
  type = map(string)
  default = {ap-northeast-2a = "10.1.4.0/24",
             ap-northeast-2b = "10.1.5.0/24",
             ap-northeast-2c = "10.1.6.0/24"}
}

variable "vpc_public_subnets" {
  type = map(string)
  default = {ap-northeast-2a = "10.1.11.0/24",
             ap-northeast-2b = "10.1.12.0/24",
             ap-northeast-2c = "10.1.13.0/24"}
}


variable "db_username" {
  type = string
  sensitive = true
}

variable "db_password" {
  type = string
  sensitive = true
}

variable "stage_ami" {
  
}