variable "access_key" {
  description = "AWS access key."
}

variable "secret_key" {
  description = "AWS secret key."
}

variable "region" {
  description = "AWS Deployment region."
  default     = "ap-southeast-1"
}

variable "availability_zones" {
  description = "AWS Deployment availability zones."
  default     = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  type        = list(string)
}
