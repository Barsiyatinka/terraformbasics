output "vms_info" {
  description = "Instance name, external IP and FQDN for all VMs"

  value = {
    web = {
      name        = yandex_compute_instance.platform.name
      external_ip = yandex_compute_instance.platform.network_interface[0].nat_ip_address
      fqdn        = yandex_compute_instance.platform.fqdn
    }

    db = {
      name        = yandex_compute_instance.db.name
      external_ip = yandex_compute_instance.db.network_interface[0].nat_ip_address
      fqdn        = yandex_compute_instance.db.fqdn
    }
  }
}
