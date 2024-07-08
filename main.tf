##### Provider #####
provider "aws"{
    region = "us-east-2"
}

##### Resource #####
resource "aws_instance" "nginx-server"{
    ami = "ami-08be1e3e6c338b037"
    instance_type = "t3.micro"
}