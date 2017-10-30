output "Instance ID" {
    value = "${aws_instance.packer-helpy.id}"
}

output "DNS" {
    value = "${aws_instance.packer-helpy.public_dns}"
}

output "Elastic IP" {
    value = "${aws_eip.default.public_ip}"
}