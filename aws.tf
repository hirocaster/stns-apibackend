variable "role" {
    default = "user"
}

variable "region" {
    default = "ap-northeast-1"
}

variable "state_bucket" {
  default = "terraform-state"
}

variable "domain_name" {
  default = "example.com"
}

variable "certificate_arn" {
  default = "arn:aws:acm:us-east-1:12345:certificate/xxxxx-xxxxx-xxxxx"
}

variable "zone_id" {
  default = "xxxxxxxxxx"
}
