build {
  name = "alma-templates"
  sources = [
    "source.proxmox-iso.Alma-9",
    "source.proxmox-iso.Alma-10",
  ]

    provisioner "shell" {
    inline = [
      "dnf update -y",
      "dnf install -y cloud-init git vim wget curl",
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
      "dnf -y autoremove",
      "dnf -y remove --oldinstallonly kernel-*",
      "dnf -y clean all",
      "truncate -s 0 /etc/machine-id",
      "rm -rf /var/log/*",
      "cloud-init clean --logs --seed",
      "sync",
      "history -c",
    ]
    expect_disconnect = true
  }

  # TODO: Check how I could disable the root user and re-comment out the PermitRootLogin for SSH

}
