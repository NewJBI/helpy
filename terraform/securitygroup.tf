resource "aws_eip" "default" {
  instance = "${aws_instance.packer-helpy.id}"
  vpc      = true

  provisioner "local-exec" {
    command = "echo 'elastic ip : ${aws_eip.default.public_ip}' >> packer_helpy_info.txt"
  }
}

resource "aws_security_group" "packer-default" {
  #vpc_id = "${aws_vpc.main.id}"
  name = "allow-ssh-packer"
  description = "security group that allows ssh and all egress traffic"
  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # HTTP access from anywhere
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags {
    Name = "allow-ssh-packer"
  }
}