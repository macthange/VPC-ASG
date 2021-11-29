
/*====
Subnets
======*/


/* database subnet */

# cidrsubnet(aws_vpc.app_vpc.cidr_block, 8, count.index) this creates /24 
resource "aws_subnet" "database_subnet" {
  count             = var.enabled ? local.resource_count : 0
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + local.resource_count + local.resource_count) #
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "database-subnet-${count.index+1}"
    Owner       = var.owner
    Environment = var.env
  }

}


/* Routing table for database subnet */
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "database-route-table"
    Owner       = var.owner
    Environment = var.env
  }
}



resource "aws_route" "database_nat_gateway" {
  count                  = var.enabled ? local.resource_count : 0
  route_table_id         = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.*.id[count.index]

}
/* aws_db_subnet_group for RDS*/
resource "aws_db_subnet_group" "rds_subnet" {
  count = var.enabled ? local.resource_count : 0

  name       = "rds_db_subnet-${count.index+1}"
  subnet_ids = aws_subnet.database_subnet.*.id

  tags = {
    Name = "rds_db_subnet-${count.index+1}"
  }
}

/* Route table associations */

resource "aws_route_table_association" "database" {
  count          = var.enabled ? local.resource_count : 0
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.database.id
}

/*====
VPC's database Security Group
======*/
resource "aws_security_group" "database" {
  name        = "${var.env}-database-sg"
  description = "database security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }

  tags = {
    Environment = var.env
  }
}


