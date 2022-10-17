# Terrafrom versions and providers
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

# Allocate a floating IP from the public IP pool
resource "openstack_networking_floatingip_v2" "egi_ui_floatip_1" {
  pool = var.public_ip_pool
}

# Creating the scorebaord server
resource "openstack_compute_instance_v2" "egi_ui" {
  name = "scoreboard"
  image_id = var.image_id
  flavor_id = var.flavor_id
  security_groups = var.security_groups
  user_data = file("cloud-init.yaml")
  network {
    uuid = var.internal_net_id
  }
}

# Attach the floating public IP to the created instance
resource "openstack_compute_floatingip_associate_v2" "egi_ui_fip_1" {
  instance_id = "${openstack_compute_instance_v2.egi_ui.id}"
  floating_ip = "${openstack_networking_floatingip_v2.egi_ui_floatip_1.address}"
}

# Create inventory file for ansible
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.cfg.tpl",
    {
      ui = "${openstack_networking_floatingip_v2.egi_ui_floatip_1.address}"
    }
  )
  filename = "./inventory/hosts.cfg"
}
