variable "AWS_ACCESS_KEY" {} #get data from terraform.tfvars 
variable "AWS_SECRET_KEY" {} #get data from terraform.tfvars
variable "AWS_REGION" {
  default = "ap-southeast-1"
}

variable "AMIS" {
  type = "map"
  default = {
    us-east-1      = "ami-82cfb894" #CentOS Linux 6 x86_64 HVM EBS 1704_01-74e73035-3435-48d6-88e0-89cc02ad83ee-ami-23285c35.4
    ap-southeast-1 = "ami-1429ac77" #CentOS Linux 6 x86_64 HVM EBS 1704_01-74e73035-3435-48d6-88e0-89cc02ad83ee-ami-23285c35.4
  }
}

variable "PRIVATE_KEY" {
  default = "" #aws private key name
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "" #path to aws private key
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "" #path to aws public key
}

variable "INSTANCE_USERNAME" {
  default = "centos" #username for ssh
}
