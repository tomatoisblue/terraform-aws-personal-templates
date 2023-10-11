variable "ec2_count" {
  default = 2
}

resource "aws_instance" "default" {
  count                  = var.ec2_count
  ami                    = data.aws_ami.default.image_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[count.index].id
  vpc_security_group_ids = [aws_security_group.default.id]
  iam_instance_profile   = "instance_role"
  user_data              = data.template_file.init.rendered

  key_name = var.key_name

  tags = {
    Name = "${format("EC2-public-%02d", count.index + 1)}-${var.availability_zones_suffix[count.index]}"
  }
}

resource "aws_iam_instance_profile" "default" {
  name = "instance_role"
  role = aws_iam_role.default.name
}

data "template_file" "init" {
  template = file("init.sh")

  vars = {
    ssh_port_num = var.ssh_port_num
    bucket_name  = var.bucket_name
  }
}

resource "aws_key_pair" "default" {
  key_name   = var.key_name
  public_key = file("./module/id_rsa.pub")
}