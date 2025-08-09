# This file is managed by Ansible
# YOUR CHANGES WILL BE LOST!
storage "file" {
  path    = "/openbao/file"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = true
}

ui               = true
api_addr         = "http://0.0.0.0:8200"
