cloud_id  = "b1gpon64gu55la4k4ve4"
folder_id = "b1g0p0vpqvuefqlcf0o2"

metadata = {
  serial-port-enable = "1"
  ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILRzCWP1FU2KRqi/0LlMltdQNiz5TgKysWpv/AJieIPH arseniy@arseniyvm"
}

vms_resources = {
  web = {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
  db = {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
}