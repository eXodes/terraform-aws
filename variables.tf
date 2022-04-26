variable "name" {
  description = "The name of the resource"
}

variable "environment" {
  description = "The environment of the resource"
}

variable "db_username" {
  description = "Database username"
  sensitive = true
}

variable "db_password" {
  description = "Database password"
  sensitive = true
}

variable "access_key" {
  description = "AWS access key."
  sensitive = true
}

variable "secret_key" {
  description = "AWS secret key."
  sensitive = true
}

variable "region" {
  description = "AWS Deployment region."
  default     = "ap-southeast-1"
}

variable "cidr_block" {
  description = "CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "private_subnets_cidr" {
  description = "CIDR block for the private subnets."
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets_cidr" {
  description = "CIDR block for the public subnets."
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "availability_zones" {
  description = "AWS Deployment availability zones."
  default     = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  type        = list(string)
}
