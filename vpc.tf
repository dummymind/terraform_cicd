resource "aws_vpc" "default_id_vpc" {
  cidr_block = "1.2.0.0/16"
}

resource "aws_vpc" "default_id_vpc2" {
  cidr_block = "1.3.0.0/16"
}

resource "aws_vpc" "default_id_vpc3" {
  cidr_block = "1.4.0.0/16"
}