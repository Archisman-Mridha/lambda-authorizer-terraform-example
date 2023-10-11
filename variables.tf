variable "region" {
  description = "AWS Region where all resource will be deployed"

  type = string
  default = "us-east-2"
}

variable "availability_zones" {
  description = "AWS Availability Zones (atleast 2) in the given region, to be used"

  type = list(string)
  default = [ "us-east-2a", "us-east-2b" ]
}

variable "credentials" {
  description = "AWS access and secret key"

  type = object({
    access_key = string
    secret_key = string
  })

  // Dummy credentials for Localstack.
  default = {
    access_key = ""
    secret_key = ""
  }
}