#################################################
# Define Cloud-init scripts to run on provisioning
#################################################


data "local_file" "cloud-config-web-txt" {
  filename        = "nginx.txt"
}

data "template_cloudinit_config" "cloud-init-config" {
  gzip            = false
  base64_encode   = false

  part {
    filename = "init.cfg"
    content_type = "text/cloud-config"
    content = "${data.local_file.cloud-config-web-txt.content}"
  }
}

