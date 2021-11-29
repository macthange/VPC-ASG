/*====
The VPC
======*/
## cidrsubnet(aws_vpc.app_vpc.cidr_block, 8, count.index) this creates /16

resource "aws_vpc" "vpc" {
  cidr_block = cidrsubnet("10.0.0.0/8", 8, lookup(var.region_number, var.region))
  tags = {
    Name        = "${var.env}-vpc"
    Owner       = var.owner
    Environment = var.env
  }
}

resource "aws_route53_zone" "public" {
  name    = local.r53_public_zone
  comment = "This is public route53_zone"
  
tags = {
    Name        = local.r53_public_zone
    Owner       = var.owner
    Environment = var.env
  }
  
}
resource "aws_route53_zone" "private" {
  name    = local.r53_private_zone
  comment = "This is private route53_zone"

  vpc {
    vpc_id = aws_vpc.vpc.id
  }
  
  tags = {
    Name        = local.r53_private_zone
    Owner       = var.owner
    Environment = var.env
  }
}

# cidrsubnet(aws_vpc.app_vpc.cidr_block, 8, count.index) this creates /24 
resource "aws_subnet" "public_subnet" {
  count = var.enabled ? local.resource_count : 0
  #count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index) #
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "public_subnet-${count.index + 1}"
    Owner       = var.owner
    Environment = var.env
  }

}

###############################################################
/*====
Subnets
======*/
/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "aws_internet_gateway"
    Owner       = var.owner
    Environment = var.env
  }
}


/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "public-route-table"
    Owner       = var.owner
    Environment = var.env
  }
}
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id


}



/* Route table associations */

resource "aws_route_table_association" "public" {
  count = var.enabled ? local.resource_count : 0
  # count          = length(data.aws_availability_zones.available.names)
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public.id
}


/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  count = var.enabled ? local.resource_count : 0
  #count      = length(data.aws_availability_zones.available.names)
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name        = "nat-eip-{count.index+1}"
    Owner       = var.owner
    Environment = var.env
  }
}

/* NAT */
resource "aws_nat_gateway" "nat_gw" {
  count = var.enabled ? local.resource_count : 0
  #count         = length(data.aws_availability_zones.available.names)
  allocation_id = aws_eip.nat_eip.*.id[count.index]
  subnet_id     = aws_subnet.public_subnet.*.id[count.index]
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name        = "nat-gateway-${count.index + 1}"
    Owner       = var.owner
    Environment = var.env
  }
}


