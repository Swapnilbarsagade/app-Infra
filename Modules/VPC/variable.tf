# vpc

variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
}

variable "vpc_name" {
    type = string
    default = "main"
}


# subnet 1

variable "subnet_1_cidr_block" {
    type = string
    default = "10.0.0.0/24"
}

variable "subnet_1_az" {
    type = string
    default = ""
}

# subnet 2

variable "subnet_2_cidr_block" {
    type = string
    default = "10.0.2.0/24"
}

variable "subnet_2_az" {
    type = string
    default = ""
}