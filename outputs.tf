## Copyright (c) 2021 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "jumpsrv_public_ip" {
  value = module.jump-server.public_ip
}

output "app_server_private_ip" {
  value = module.app-server.*.private_ip
}

output "win_server_private_ip" {
  value = module.win-server.*.private_ip
}

output "generated_ssh_private_key" {
  value     = nonsensitive(tls_private_key.ssh_key.private_key_pem)
}
