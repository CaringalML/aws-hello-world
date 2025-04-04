# Provider configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "mysql" {
  name        = "mysql-security-group"
  description = "Security group for MySQL database access"
  vpc_id      = var.vpc_id

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

# Variables needed for this resource
variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to connect to MySQL"
  type        = list(string)
  default     = ["10.0.0.0/16"] # Default to the VPC CIDR - should be modified for production
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

# Output the security group ID for reference by other resources
output "mysql_security_group_id" {
  value       = aws_security_group.mysql.id
  description = "The ID of the MySQL security group"
}