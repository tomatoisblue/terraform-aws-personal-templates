resource "aws_subnet" "private" {
  count =2
  cidr_block        = cidrsubnet(aws_vpc.default.cidr_block, 8, count.index + length(aws_subnet.public))
  availability_zone = var.availability_zones[count.index]
  vpc_id            = aws_vpc.default.id

  map_public_ip_on_launch = false

  tags = {
    Name = "${format("private-%02d", count.index + 1)}-${var.availability_zones_suffix[count.index]}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.prefix}-private-route-table"
  }
}

resource "aws_route" "private" {
  nat_gateway_id         = aws_nat_gateway.default.id
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}