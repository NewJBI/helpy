output "Instance ID" {
    value = "${aws_instance.packer-helpy.id}"
}

output "Public IP" {
    value = "${aws_instance.packer-helpy.public_ip}"
}

output "DNS" {
    value = "${aws_instance.packer-helpy.public_dns}"
}

output "elastic ip" {
    value = "${aws_eip.default.public_ip}"
}