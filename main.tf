resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

# Primary subnet (ru-central1-a)
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

# Secondary subnet (ru-central1-b) — for DB VM
resource "yandex_vpc_subnet" "develop_b" {
  name           = "${var.vpc_name}-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_family
}

resource "yandex_compute_instance" "platform" {
  name        = local.vm_web_full_name
  platform_id = var.vm_web_platform_id

  resources {
    cores         = var.vms_resources["web"].cores
    memory        = var.vms_resources["web"].memory
    core_fraction = var.vms_resources["web"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_web_nat
  }

  #metadata = {
  #  serial-port-enable = var.vm_web_serial_port_enable
  #  ssh-keys           = "${var.vm_web_ssh_user}:${var.vms_ssh_root_key}"
  #}
  metadata = var.metadata
}

resource "yandex_compute_instance" "db" {
  zone        = "ru-central1-b"
  name        = local.vm_db_full_name
  platform_id = var.vm_db_platform_id

  resources {
    cores         = var.vms_resources["db"].cores
    memory        = var.vms_resources["db"].memory
    core_fraction = var.vms_resources["db"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop_b.id
    nat       = var.vm_db_nat
  }

  #metadata = {
  #  serial-port-enable = var.vm_db_serial_port_enable
  #  ssh-keys           = "${var.vm_db_ssh_user}:${var.vms_ssh_root_key}"
  #}
  metadata = var.metadata
}

