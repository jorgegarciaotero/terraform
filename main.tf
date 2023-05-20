provider "aws" {
    region = "eu-west-2"
}

resource "aws_instance" "mi_servidor" {
    ami = "ami-007ec828a062d87a5"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.mi_grupo_de_seguridad.id]
    user_data = <<-EOF
    #!/bin/bash

    # Instalación de Docker
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce

    # Corriendo Jenkins en Docker
    sudo docker run -p 8080:8080 -p 50000:50000 jenkins/jenkins

    EOF

    tags = {
        "key" = "servidor-1"
    }
}

resource "aws_security_group" "mi_grupo_de_seguridad"{
    name = "primer-servidor-sg"

    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        description = "Acceso al puerto 8080 desde el exterior"
        from_port = 8080
        to_port = 8080
        protocol = "TCP"
    }

    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH Access"
        from_port   = 22
        to_port     = 22
        protocol    = "TCP"
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
