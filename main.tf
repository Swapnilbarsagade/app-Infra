module "VPC" {
    source = "./Modules/VPC"
    vpc_cidr_block = "10.0.0.0/16"
    vpc_name = "main"
    subnet_1_cidr_block = "10.0.0.0/24"
    subnet_1_az = "ap-northeast-2a"
    subnet_2_cidr_block = "10.0.1.0/24"
    subnet_2_az = "ap-northeast-2b"
}