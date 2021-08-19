  
provider "aws" {
  region = "us-east-1"
}

locals {
  name   = "blue-app"
  region = "us-east-1"
  tags = {
    Environment = "development"
    Name        = "app-blue"
  }
  user_data = <<EOF
  sudo yum update -y
  sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
  sudo yum install -y httpd
  sudo systemctl start httpd
  sudo systemctl enable httpd
  sudo chown -R ec2-user:apache /var/www
  sudo chmod 2775 /var/www
  find /var/www -type d -exec sudo chmod 2775 {} \;
  find /var/www -type f -exec sudo chmod 0664 {} \;
  cd /var/www/html
  echo "Welcome to applicatio Blue" >> index.html
  EOF
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "../modules/vpc"

  name = local.name
  cidr = "20.10.0.0/16" # 10.0.0.0/8 is reserved for EC2-Classic

  azs                 = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets     = ["20.10.1.0/24", "20.10.2.0/24", "20.10.3.0/24"]
  public_subnets      = ["20.10.11.0/24", "20.10.12.0/24", "20.10.13.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  #default_security_group_name = module.new_security_group.name

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60

  tags = local.tags
}

################################################################################
# Security Group Module
################################################################################
module "new_security_group" {
  source = "../modules/security_group"

  name = "blue-sg"
  vpc_id = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp","http-80-tcp","ssh-tcp"]
  egress_rules        = ["all-all"]

  tags = local.tags
}

################################################################################
# EC2 Module
################################################################################
module "ec2" {
  source = "../modules/ec2"

  instance_count = var.instances_number
  name          = "blue-app"
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = tolist(data.aws_subnet_ids.all.ids)[0]
  vpc_security_group_ids      = [module.new_security_group.security_group_id]
  associate_public_ip_address = var.associate_public_ip_address

  user_data_base64 = base64encode(local.user_data)
  
  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 10
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp2"
      volume_size = 5
    }
  ]

  tags = local.tags

}

################################################################################
# VPC Endpoints Module
################################################################################

module "vpc_endpoints" {
  source = "../modules/vpc-endpoints"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [data.aws_security_group.default.id]

  endpoints = {
  	ec2 = {
      service             = "ec2"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
  }

  tags = local.tags
}


################################################################################
# Supporting Resources
################################################################################

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

data "aws_subnet_ids" "all" {
  vpc_id = module.vpc.vpc_id
}