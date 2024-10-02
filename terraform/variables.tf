variable "aws_region" {
  description = "The AWS region to deploy resources."
  default = "us-east-1"
}

variable "key_name" {
  description = "Name of SSH Key"
  default = "mykey"
}   

variable "ssh_private_key" {
  description = "SSH private key content"
  type        = string
  sensitive   = true  # Mark it as sensitive to avoid logging the value
}
