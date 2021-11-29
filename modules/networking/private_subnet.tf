
/*====
Subnets
======*/


/* Private subnet */

# cidrsubnet(aws_vpc.app_vpc.cidr_block, 8, count.index) this creates /24 
resource "aws_subnet" "private_subnet" {
  count             = var.enabled ? local.resource_count : 0
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + local.resource_count) #
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "private-subnet-${count.index + 1}"
    Owner       = var.owner
    Environment = var.env
  }

}


/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "private-route-table"
    Owner       = var.owner
    Environment = var.env
  }
}



resource "aws_route" "private_nat_gateway" {
  count                  = var.enabled ? local.resource_count : 0
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.*.id[count.index]

}

/* Route table associations */

resource "aws_route_table_association" "private" {
  count          = var.enabled ? local.resource_count : 0
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.private.id
}

