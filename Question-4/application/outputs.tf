# Security Group
output "security_group_id" {
  description = "The ID of the security group"
  value       = module.new_security_group.security_group_id
}

# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

# VPC endpoints
output "vpc_endpoint_ssm_id" {
  description = "The ID of VPC endpoint for SSM"
  value       = module.vpc_endpoints.endpoints["ec2"].id
}

output "instances_public_ips" {
  description = "Public IPs assigned to the EC2 instance"
  value       = module.ec2.public_ip
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2.id[0]
}