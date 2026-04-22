# Rocky Linux 9 & 10
# ---
# Packer template to create an Rocky Linux 9 & 10 Template on Proxmox.

locals {
  rocky_9_vm_id = 1001
  rocky_10_vm_id = 1002
}

source "proxmox-iso" "Rocky-9" {
  # Proxmox Connection Settings
  proxmox_url = var.proxmox_api_url
  username = var.proxmox_api_token_id
  token = var.proxmox_api_token_secret
  insecure_skip_tls_verify = true

  # VM/Template Hardware General Settings
  node = "pve"
  vm_id = local.rocky_9_vm_id
  vm_name = "rocky-9"
  template_description = "Rocky 9 Template"
  pool = "Templates"
  tags = "Template"

  # VM/Template Hardware OS Settings
  os = "l26" # Linux 2.6+
  boot_iso {
    type = "scsi"
    # iso_url = "https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.7-x86_64-dvd.iso"
    # iso_storage_pool = "local"
    # iso_download_pve = true
    iso_file = "local:iso/Rocky-9.7-x86_64-dvd.iso"
    unmount = true
    iso_checksum = "d48e902325dce6793935b4e13672a0d9a4f958e02d4e23fcf0a8a34c49ef03da"
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
    "<up><wait>",
    "<tab><wait>",
    "<end><wait>",
    " text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<wait>",
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


source "proxmox-iso" "Rocky-10" {
  # Proxmox Connection Settings
  proxmox_url = var.proxmox_api_url
  username = var.proxmox_api_token_id
  token = var.proxmox_api_token_secret
  insecure_skip_tls_verify = true

  # VM/Template Hardware General Settings
  node = "pve"
  vm_id = local.rocky_10_vm_id
  vm_name = "rocky-10"
  template_description = "Rocky 10 Template"
  pool = "Templates"
  tags = "Template"

  # VM/Template Hardware OS Settings
  os = "l26" # Linux 2.6+
  boot_iso {
    type = "scsi"
    # iso_url = "https://download.rockylinux.org/pub/rocky/10/isos/x86_64/Rocky-10.1-x86_64-dvd1.iso"
    # iso_storage_pool = "local"
    # iso_download_pve = true
    iso_file = "local:iso/Rocky-10.1-x86_64-dvd1.iso"
    unmount = true
    iso_checksum = "55f96d45a052c0ed4f06309480155cb66281a008691eb7f3f359957205b1849a"
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
    "<up><wait>",
    "e<wait>",
    "<down><down><end><wait>",
    " text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<wait>",
    "<f10><wait>"
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

