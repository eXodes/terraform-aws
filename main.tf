module "vpc" {
  source  = "registry.terraform.io/terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = var.name
  cidr = var.cidr_block

  azs             = var.availability_zones
  private_subnets = var.private_subnets_cidr
  public_subnets  = var.public_subnets_cidr

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = var.environment
  }
}

# Security Group
module "public-sg" {
  source  = "registry.terraform.io/terraform-aws-modules/security-group/aws//modules/http-80"
  version = "4.9.0"

  name        = "${var.name}-public-sg"
  description = "Public security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
}

module "private-sg" {
  source  = "registry.terraform.io/terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "${var.name}-private-sg"
  description = "Private security group for private subnets with SSH ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
  ingress_rules       = ["ssh-tcp", "postgresql-tcp"]
}

# Launch Template
resource "aws_launch_template" "web" {
  name_prefix            = "public-lt-${var.name}-"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.public-sg.security_group_id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_template" "app" {
  name_prefix            = "private-lt-${var.name}-"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.private-sg.security_group_id]

  monitoring {
    enabled = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto-Scaling Group
module "web-asg" {
  source  = "registry.terraform.io/terraform-aws-modules/autoscaling/aws"
  version = "6.3.0"

  name = "${var.name}-web-asg"

  vpc_zone_identifier       = module.vpc.public_subnets
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"

  create_launch_template = false
  launch_template        = aws_launch_template.web.name

  tags = {
    Environment = var.environment
  }
}

module "app-asg" {
  source  = "registry.terraform.io/terraform-aws-modules/autoscaling/aws"
  version = "6.3.0"

  name = "${var.name}-app-asg"

  vpc_zone_identifier = module.vpc.private_subnets

  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"

  create_launch_template = false
  launch_template        = aws_launch_template.app.name

  tags = {
    Environment = var.environment
  }
}

# Database
module "db" {
  source = "registry.terraform.io/terraform-aws-modules/rds/aws"

  identifier = "${var.name}-rds"

  engine               = "postgres"
  engine_version       = "12"
  family               = "postgres12"
  major_engine_version = "12"
  instance_class       = "db.t2.micro"
  allocated_storage    = "5"
  availability_zone    = module.vpc.azs[0]

  db_name  = "${var.name}db"
  username = var.db_username
  password = var.db_password
  port     = "3306"

  create_db_subnet_group = true
  vpc_security_group_ids = [module.private-sg.security_group_id]
  subnet_ids             = module.vpc.private_subnets

  storage_encrypted       = false
  backup_retention_period = 0
  deletion_protection     = false # set to true to prevent accidental deletion

  tags = {
    Environment = var.environment
  }

}

# Load Balancer
module "lb" {
  source  = "registry.terraform.io/terraform-aws-modules/alb/aws"
  version = "6.10.0"

  name = "${var.name}-lb"

  load_balancer_type = "network"

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "ip"
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = var.environment
  }
}
