resource "aws_eip" "default" {
  instance = "${aws_instance.packer-helpy.id}"
  vpc      = true

  provisioner "local-exec" {
    command = "echo 'elastic ip : ${aws_eip.default.public_ip}' >> helpy-info.txt"
  }
}

resource "aws_security_group" "web-default" {
  name = "helpy-security"
  description = "security group that allows ssh, http, https and all egress traffic"

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

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
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
      Name = "helpy-security"
  }
}