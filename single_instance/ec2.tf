data "aws_ami" "example" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}


resource "aws_instance" "example" {
  ami                    = data.aws_ami.example.image_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.example.id
  vpc_security_group_ids = [aws_security_group.example.id]
  user_data              = data.template_file.init.rendered

  key_name = var.key_name

  tags = {
    Name = "${var.prefix}-instance"
  }
}

data "template_file" "init" {
  template = file("init.sh")

  vars = {
    ssh_port_num = var.ssh_port_num
  }
}

resource "aws_key_pair" "example" {
  key_name   = var.key_name
  public_key = file("id_rsa.pub")
}