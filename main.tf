##### Provider #####
provider "aws"{
    region = "us-east-2"
}

##### Resource #####
resource "aws_instance" "nginx-server"{
    ami = "ami-08be1e3e6c338b037"
    instance_type = "t3.micro"
    user_data = <<-EOF
                #!/bin/bash
                sudo yum install -y nginx
                sudo systemctl enable nginx
                sudo systemctl start nginx
                EOF
    
    #Linkear llave con este recurso
    key_name = aws_key_pair.nginx-server-ssh.key_name

    #Asignamos el SG
    vpc_security_group_ids               = [
        aws_security_group.nginx-server-sg.id
    ]
}

#Comando para crear la llave
#ssh-keygen -t rsa -b 2048 -f "nginx-server.key"
##Crea la instancia y sube la llave a AWS

resource "aws_key_pair" "nginx-server-ssh" {
    key_name = "nginx -server-ssh"
    public_key = file("nginx-server.key.pub")
}

####### SG ####### 
resource "aws_security_group" "nginx-server-sg" {
  name        = "nginx-server-sg"
  description = "Security group allowing SSH and HTTP access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  #Acepta todos los puertos
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}