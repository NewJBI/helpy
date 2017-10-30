resource "aws_instance" "packer-helpy" {
  ami           = "${var.AMI_ID}"
  instance_type = "${var.INSTANCE_TYPE}"

  # security group
  vpc_security_group_ids = ["${aws_security_group.web-default.id}"]

  # public SSH key
  key_name = "${var.PRIVATE_KEY}"
  
  # connection for previsioner
  connection = {
    user = "${var.INSTANCE_USERNAME}"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }

  provisioner "file" {
    source = "./scripts/web-server.conf"
    destination = "/tmp/web-server.conf",
  }

  provisioner "file" {
    source = "./scripts/nginx.conf"
    destination = "/tmp/nginx.conf",
  }

  provisioner "file" {
    source = "./scripts/logrotate_rails"
    destination = "/tmp/logrotate_rails",
  }

  provisioner "file" {
    source = "./scripts/init.sh"
    destination = "/tmp/init.sh",
  }

  provisioner "local-exec" {
    command = "echo 'instance id : ${aws_instance.packer-helpy.id}\nprivate ip : ${aws_instance.packer-helpy.private_ip}\npublic ip : ${aws_instance.packer-helpy.public_ip}' > helpy-info.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/init.sh",
      "sed -i -e 's#{ssh_public_key}#${aws_key_pair.deployer.public_key}#g' /tmp/init.sh",
      "sudo bash /tmp/init.sh",
      "sudo rm -rf /tmp/init.sh"
    ]
  }

  tags {
    Name = "Helpy ${timestamp()}"
  }

}