variable "cidr" {}
variable "name" {}
variable "ssh_port_num" {
  default = 8637
}
variable "az" {}
variable "key_name" {
  default = "test-key"
}
variable "instance_type" {
  default = "t2.nano"
}

resource "aws_vpc" "default" {
  cidr_block = var.cidr

  tags = {
    Name = var.name
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.name}-gw"
  }
}

resource "aws_security_group" "default" {
  vpc_id = aws_vpc.default.id
  name   = "${var.name}-sg"

  tags = {
    Name = "${var.name}-sg"
  }
}

resource "aws_security_group_rule" "ssh_in" {
  type              = "ingress"
  from_port         = var.ssh_port_num
  to_port           = var.ssh_port_num
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "http_in" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "https_in" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}


resource "aws_security_group_rule" "all_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_subnet" "public" {
  cidr_block        = cidrsubnet(aws_vpc.default.cidr_block, 8, 0)
  availability_zone = var.az
  vpc_id            = aws_vpc.default.id

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.name}-public-route-table"
  }
}

resource "aws_route" "public" {
  gateway_id             = aws_internet_gateway.default.id
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

data "aws_ami" "default" {
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


resource "aws_instance" "default" {
  ami                    = data.aws_ami.default.image_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.default.id]
  user_data              = data.template_file.init.rendered

  key_name = var.key_name

  tags = {
    Name = "${var.name}-instance"
  }
}

data "template_file" "init" {
  template = file("./init.sh")

  vars = {
    ssh_port_num = var.ssh_port_num
  }
}

resource "aws_key_pair" "default" {
  key_name   = var.key_name
  public_key = file("./id_rsa.pub")
}
