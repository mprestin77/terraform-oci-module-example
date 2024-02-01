module "network" { 
  source = "./modules/network"
  tenancy_ocid = var.tenancy_ocid
  compartment_ocid = var.compartment_ocid
  region = var.region
  use_existing_vcn = var.use_existing_vcn
  vcn_cidr = var.network_params["vcn_cidr"]
  public_subnet_cidr = var.network_params["public_subnet_cidr"]
  private_subnet_cidr = var.network_params["private_subnet_cidr"]
  vcn_name = var.network_params["vcn_name"]
  vcn_dns_label  = var.network_params["vcn_dns_label"]
  vcn_id = var.vcn_id
  public_subnet_id = var.public_subnet_id
  private_subnet_id = var.private_subnet_id
}

module "jump-server" {
  depends_on = [module.network]
  source = "./modules/compute"
  user_data = base64encode(file("userdata/scripts/cloudinit.sh")) 
  compartment_ocid = var.compartment_ocid
  availability_domain = local.availability_domain_name
  instance_name = var.instance1["name"]
  instance_shape   = var.instance1["shape"]
  ocpu = var.instance1["ocpu"]
  memory = var.instance1["memory"]
  os = var.instance1["os"]
  os_version = var.instance1["os_version"]
  create_in_private_subnet = var.instance1["create_in_private_subnet"]
  subnet_id = var.use_existing_vcn ? var.public_subnet_id : module.network.public_subnet_id
  ssh_public_key = tls_private_key.ssh_key.public_key_openssh 
  num_instances = 1
}

module "app-server" {
  depends_on = [module.network]
  source = "./modules/compute"
  user_data = base64encode(file("userdata/scripts/cloudinit.sh")) 
  compartment_ocid = var.compartment_ocid
  availability_domain = local.availability_domain_name
  instance_name = var.instance2["name"]
  instance_shape   = var.instance2["shape"]
  ocpu = var.instance2["ocpu"]
  memory = var.instance2["memory"]
  os = var.instance2["os"]
  os_version = var.instance2["os_version"]
  create_in_private_subnet = var.instance2["create_in_private_subnet"]
  subnet_id = var.use_existing_vcn ? var.private_subnet_id : module.network.private_subnet_id
  ssh_public_key = tls_private_key.ssh_key.public_key_openssh 
  num_instances = 2
}

module "win-server" {
  depends_on = [module.network]
  source = "./modules/compute"
  user_data = base64encode(file("userdata/scripts/cloudinit.sh")) 
  compartment_ocid = var.compartment_ocid
  availability_domain = local.availability_domain_name
  instance_name = var.instance3["name"]
  instance_shape   = var.instance3["shape"]
  ocpu = var.instance3["ocpu"]
  memory = var.instance3["memory"]
  os = var.instance3["os"]
  os_version = var.instance3["os_version"]
  create_in_private_subnet = var.instance3["create_in_private_subnet"]
  subnet_id = var.use_existing_vcn ? var.private_subnet_id : module.network.private_subnet_id
  ssh_public_key = tls_private_key.ssh_key.public_key_openssh 
  num_instances = 1
}

module "bastion" {
  depends_on = [module.network]
  source = "./modules/bastion"
  compartment_ocid = var.compartment_ocid
  subnet_id = var.use_existing_vcn ? var.private_subnet_id : module.network.private_subnet_id
  create_bastion = var.create_bastion
}
