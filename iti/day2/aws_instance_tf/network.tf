resource "aws_vpc" "jen_vpc" {
    cidr_block =                    var.vpc_cidr
    enable_dns_hostnames =          true
    enable_dns_support =            true
    tags = {
        Name=                       "Jenkins VPC"
    }
}

resource "aws_internet_gateway" "jen_igw" {
    vpc_id =                        aws_vpc.jen_vpc.id
    tags = {
        Name=                       "Jenkins IGW"
    }
}

resource "aws_route_table" "jen_route_table" {
    vpc_id =                        aws_vpc.jen_vpc.id

    route {
        cidr_block =                var.vpc_cidr
        gateway_id =                "local"
    }
    route {
        cidr_block =                "0.0.0.0/0"
        gateway_id =                aws_internet_gateway.jen_igw.id
    }

    tags = {
        Name=                       "Jenkins Public Route Table"
    }
}

resource "aws_subnet" "jen_subnet" {
    vpc_id =                        aws_vpc.jen_vpc.id
    cidr_block =                    var.subnet_cidr
    map_public_ip_on_launch =       true
    availability_zone =             "us-east-1a"
    tags = {
        Name=                       "Jenkins Public Subnet"
    }
}

resource "aws_route_table_association" "jen_rt_assoc" {
    subnet_id =                     aws_subnet.jen_subnet.id
    route_table_id =                aws_route_table.jen_route_table.id
}