# Debian 12 & 13
# ---
# Packer template to create an Debian 12 & 13 Template on Proxmox.

locals {
  debian_12_vm_id = 2101
  debian_13_vm_id = 2102
}

source "proxmox-iso" "debian-12" {
  # Proxmox Connection Settings
  proxmox_url = var.proxmox_api_url
  username = var.proxmox_api_token_id
  token = var.proxmox_api_token_secret
  insecure_skip_tls_verify = true

  # VM/Template Hardware General Settings
  node = "pve"
  vm_id = local.debian_12_vm_id
  vm_name = "debian-12"
  template_description = "Debian 12 Template"
  pool = "Templates"
  tags = "Template"

  # VM/Template Hardware OS Settings
  os = "l26" # Linux 2.6+
  boot_iso {
    type = "scsi"
    iso_url = "https://cdimage.debian.org/cdimage/archive/12.12.0/amd64/iso-cd/debian-12.12.0-amd64-netinst.iso"
    iso_storage_pool = "local"
    iso_download_pve = true
    #iso_file = "local:iso/debian-12.12.0-amd64-netinst.iso"
    unmount = true
    iso_checksum = "dfc30e04fd095ac2c07e998f145e94bb8f7d3a8eca3a631d2eb012398deae531"
  }

  # VM/Template Hardware System Settings
  bios = "seabios"
  machine = "pc"
  scsi_controller = "virtio-scsi-single"
  qemu_agent = true

  # VM/Template Hardware Disks Settings
  disks {
    type = "scsi"
    storage_pool = "NVMe_Array"
    disk_size = "64G"
    format = "raw"
    io_thread = true
    discard = true
  }

  # VM/Template Hardware CPU Settings
  sockets = 1
  cores = 4
  cpu_type = "x86-64-v3"

  # VM/Template Hardware Memory Settings
  memory = 4096
  ballooning_minimum = 4096

  # VM/Template Hardware Network Settings
  network_adapters {
    model = "virtio"
    bridge = "vmbr0"
    firewall = true
  }

  # VM/Template Hardware VirtIO RNG Settings
  rng0 {
    source = "/dev/urandom"
    max_bytes = 1024
    period = 1000
  }

  # VM/Template Hardware CloudInit Drive Settings
  cloud_init = true
  cloud_init_storage_pool = "NVMe_Array"
  cloud_init_disk_type = "ide"

  # VM/Template Boot Order Settings
  boot = "order=scsi0;net0;scsi1"

  # Wait time before executing the boot commands
  boot_wait = "15s"

  # Boot Commands
  # This is like pressing those keys or entering that text when the VM boots
  boot_command = [
    "<esc><wait>",
    "auto<wait> ",
    "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<wait>",
    "<enter><wait>"
  ]

  # Packer Autoinstall Settings
  http_directory = "http"
  http_port_min = 8800
  http_port_max = 8810

  # SSH info that Packer will use once CloudInit/AutoInstall is done
  ssh_username = "${var.ssh_username}"
  ssh_password = "${var.ssh_password}"
  ssh_timeout = "5m"
  ssh_pty = true
}


source "proxmox-iso" "debian-13" {
  # Proxmox Connection Settings
  proxmox_url = var.proxmox_api_url
  username = var.proxmox_api_token_id
  token = var.proxmox_api_token_secret
  insecure_skip_tls_verify = true

  # VM/Template Hardware General Settings
  node = "pve"
  vm_id = local.debian_13_vm_id
  vm_name = "debian-13"
  template_description = "Debian 13 Template"
  pool = "Templates"
  tags = "Template"

  # VM/Template Hardware OS Settings
  os = "l26" # Linux 2.6+
  boot_iso {
    type = "scsi"
    iso_url = "https://cdimage.debian.org/debian-cd/13.2.0/amd64/iso-cd/debian-13.2.0-amd64-netinst.iso"
    iso_storage_pool = "local"
    iso_download_pve = true
    #iso_file = "local:iso/debian-13.2.0-amd64-netinst.iso"
    unmount = true
    iso_checksum = "677c4d57aa034dc192b5191870141057574c1b05df2b9569c0ee08aa4e32125d"
  }

  # VM/Template Hardware System Settings
  bios = "seabios"
  machine = "pc"
  scsi_controller = "virtio-scsi-single"
  qemu_agent = true

  # VM/Template Hardware Disks Settings
  disks {
    type = "scsi"
    storage_pool = "NVMe_Array"
    disk_size = "64G"
    format = "raw"
    io_thread = true
    discard = true
  }

  # VM/Template Hardware CPU Settings
  sockets = 1
  cores = 4
  cpu_type = "x86-64-v3"

  # VM/Template Hardware Memory Settings
  memory = 4096
  ballooning_minimum = 4096

  # VM/Template Hardware Network Settings
  network_adapters {
    model = "virtio"
    bridge = "vmbr0"
    firewall = true
  }

  # VM/Template Hardware VirtIO RNG Settings
  rng0 {
    source = "/dev/urandom"
    max_bytes = 1024
    period = 1000
  }

  # VM/Template Hardware CloudInit Drive Settings
  cloud_init = true
  cloud_init_storage_pool = "NVMe_Array"
  cloud_init_disk_type = "ide"

  # VM/Template Boot Order Settings
  boot = "order=scsi0;net0;scsi1"

  # Wait time before executing the boot commands
  boot_wait = "15s"

  # Boot Commands
  # This is like pressing those keys or entering that text when the VM boots
  boot_command = [
    "<esc><wait>",
    "auto<wait> ",
    "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<wait>",
    "<enter><wait>"
  ]

  # Packer Autoinstall Settings
  http_directory = "http"
  http_port_min = 8800
  http_port_max = 8810

  # SSH info that Packer will use once CloudInit/AutoInstall is done
  ssh_username = "${var.ssh_username}"
  ssh_password = "${var.ssh_password}"
  ssh_timeout = "5m"
  ssh_pty = true
}

