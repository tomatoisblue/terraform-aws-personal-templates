resource "aws_subnet" "public" {
  count             = 2
  cidr_block        = cidrsubnet(aws_vpc.default.cidr_block, 8, count.index)
  availability_zone = var.availability_zones[count.index]
  vpc_id            = aws_vpc.default.id

  map_public_ip_on_launch = true

  tags = {
    Name = "${format("public-%02d", count.index + 1)}-${var.availability_zones_suffix[count.index]}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.prefix}-public-route-table"
  }
}

resource "aws_route" "public" {
  gateway_id             = aws_internet_gateway.default.id
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}