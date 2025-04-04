resource "aws_security_group" "mysql" {
  name        = "mysql-security-group"
  description = "Security group for MySQL database access"
  vpc_id      = aws_vpc.main.id

  # MySQL port
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
    description = "MySQL access"
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "mysql-security-group"
    Environment = var.environment
    Terraform   = "true"
  }
}

resource "aws_security_group" "alb" {
  name        = "alb-security-group-caringals"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access"
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "alb-security-group"
    Environment = var.environment
    Terraform   = "true"
  }
}

# Output the security group ID for reference by other resources
output "mysql_security_group_id" {
  value       = aws_security_group.mysql.id
  description = "The ID of the MySQL security group"
}

output "alb_security_group_id" {
  value       = aws_security_group.alb.id
  description = "The ID of the ALB security group"
}