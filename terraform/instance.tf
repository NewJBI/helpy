resource "aws_instance" "packer-helpy" {
  ami           = "${var.AMI_ID}"
  instance_type = "t2.micro"

  # security group
  vpc_security_group_ids = ["${aws_security_group.packer-default.id}"]

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

  provisioner "local-exec" {
    command = "echo 'instance id : ${aws_instance.packer-helpy.id}\nprivate ip : ${aws_instance.packer-helpy.private_ip}\npublic ip : ${aws_instance.packer-helpy.public_ip}' > packer_helpy_info.txt"
  }

  provisioner "remote-exec" {
   inline = [
      "sudo rm -rf /etc/nginx/conf.d/default.conf",
      "sudo mv /tmp/nginx.conf /etc/nginx/.",
      "sudo mv /tmp/web-server.conf /etc/nginx/conf.d/.",
      "sudo service nginx start",
      "sudo mv /tmp/logrotate_rails /etc/logrotate.d/rails",
      "sudo logrotate -f /etc/logrotate.conf"
   ]
  }

  tags {
    Name = "Helpy ${timestamp()}"
  }

}
