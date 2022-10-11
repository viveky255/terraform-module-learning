provider "aws"{
    region = "ap-south-1"
}


resource "aws_vpc" "myapp_vpc" {
    cidr_block = var.vpc_cidr_block
    instance_tenancy     = "default"
    enable_dns_support   = "true"
    enable_dns_hostnames = "true"
    tags = {
      "Name" = "${var.env_prefix}-vpc"
    }
  
}

module "myapp-subnet" {
    source = "./modules/subnet"
    subnet_cidr_block = var.subnet_cidr_block
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
    vpc_id = aws_vpc.myapp_vpc.id
    default_route_table_id = aws_vpc.myapp_vpc.default_route_table_id
}

module "myapp-server" {
    source = "./modules/webserver"
    vpc_id = aws_vpc.myapp_vpc.id
    my_ip = var.my_ip
    env_prefix = var.env_prefix
    image_name = var.image_name
    instance_type = var.instance_type
    subnet_id = module.myapp-subnet.subnet.id
    avail_zone = var.avail_zone
}

