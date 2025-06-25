provider "aws" {
  region = "ap-south-1"
}

resource "aws_key_pair" "revanth_key" {
  key_name   = "revanth-key"
  public_key = file("/Users/revanth/.ssh/revanth-key.pub")
}

resource "aws_security_group" "fastapi_sg" {
  name        = "fastapi-sg"
  description = "Allow SSH and app access"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "fastapi_ec2" {
  ami                    = "ami-0f58b397bc5c1f2e8"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.revanth_key.key_name
  security_groups        = [aws_security_group.fastapi_sg.name]
  associate_public_ip_address = true

  tags = {
    Name = "fastapi-app-instance"
  }

  provisioner "remote-exec" {
    inline = [
      "echo Connected successfully!"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/Users/revanth/.ssh/revanth-key")
      host        = self.public_ip
    }
  }
}
