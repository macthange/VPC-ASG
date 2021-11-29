locals {
  web-sg      = "${var.prefix}-web-sg-${var.env}-${local.region_code}"
  app-sg      = "${var.prefix}-app-sg-${var.env}-${local.region_code}"
  ssh-sg      = "${var.prefix}-ssh-sg-${var.env}-${local.region_code}"
  outbound-sg = "${var.prefix}-outbound-sg-${var.env}-${local.region_code}"
  db-sg       = "${var.prefix}-db-sg-${var.env}-${local.region_code}"
  alb-sg      = "${var.prefix}-alb-sg-${var.env}-${local.region_code}"

}

resource "aws_security_group" "outbound_sg" {
  name        = local.outbound-sg
  description = "Security Group allowing all outbound access"
  vpc_id      = var.vpc_id


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(map(
    "Name", local.outbound-sg
  ), var.tags)
}
resource "aws_security_group" "admin_sg" {
  name        = local.ssh-sg
  description = "admin Security Group allowing ssh & rdp inbound access"
  vpc_id      = var.vpc_id


  egress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(map(
    "Name", local.ssh-sg
  ), var.tags)
}
resource "aws_security_group" "alb_sg" {
  name        = local.alb-sg
  description = "ALB Security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "https"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "http"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(map(
    "Name", local.alb-sg
  ), var.tags)
}
resource "aws_security_group" "web_sg" {
  name        = local.web-sg
  description = "web Security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "https"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 6005 ## FIx Me this informaica applica port used as example 
    to_port     = 6005 ## FIx Me this informaica applica port used as example
    protocol    = "http"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(map(
    "Name", local.web-sg
  ), var.tags)
}
resource "aws_security_group" "app_sg" {
  name        = local.app-sg
  description = "Application Security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 6005 ## FIx Me this informaica applica port used as example 
    to_port     = 6005 ## FIx Me this informaica applica port used as example
    protocol    = "https"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(map(
    "Name", local.app-sg
  ), var.tags)
}

resource "aws_security_group" "db_sg" {
  name        = local.db-sg
  description = "database Security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(map(
    "Name", local.db-sg
  ), var.tags)
}


