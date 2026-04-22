build {
  name = "debian-templates"
  sources = [
    "source.proxmox-iso.debian-12",
    "source.proxmox-iso.debian-13",
  ]

  provisioner "shell" {
    inline = [
      "apt install -y cloud-init cloud-initramfs-growroot",
      "reboot",
    ]
    expect_disconnect = true
  }

  provisioner "file" {
    source = "cloud-init-config/99-pve.cfg"
    destination = "/tmp/99-pve.cfg"
  }

  provisioner "shell" {
    inline = [
      "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg"
    ]
  }

  provisioner "shell" {
    inline = [
      "rm /etc/ssh/ssh_host_*",
      "apt -y autoremove --purge",
      "apt -y clean",
      "truncate -s 0 /etc/machine-id",
      "rm -f /var/lib/dbus/machine-id",
      "ln -sf /etc/machine-id /var/lib/dbus/machine-id",
      "rm -f /etc/udev/rules.d/70-persistent-net.rules",
      "rm -f /var/lib/systemd/random-seed",
      "rm -rf /var/log/*",
      "cloud-init clean --logs --seed",
      "sync",
    ]
  }

  # TODO: Check how I could disable the root user and re-comment out the PermitRootLogin for SSH

}

