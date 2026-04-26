variable "tools" {
  default = {
      vault = {
        port = 8200
        volume_size = 20
        instance_type = "t3.small"
      }
      github-runner = {
        port = 80 # Just a dummy port
        volume_size = 20
        instance_type = "t3.small"
    }
    }
  }

variable "zone_id" {
  default = "Z08535891FNQ7VOKD83G7"
}

variable "domain_name" {
  default = "sairamdevops.online"
}