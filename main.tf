resource "aws_key_pair" "key-tf" {
  key_name   = "tf-key"
  public_key = file("${path.module}/id_rsa.pub")

}

output "keyname" {
  value = aws_key_pair.key-tf.key_name

}


resource "aws_instance" "web" {
  ami                         = "ami-067aaeea6813afbde"
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.instance.id]
  associate_public_ip_address = true


  key_name = aws_key_pair.key-tf.key_name

  tags = {
    Name = "tf-instance"
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("${path.module}/id_rsa")
    host = self.public_ip

  }

  provisioner "local-exec" {
    command ="echo 'ec2-instance created'"
    
  }
  provisioner "remote-exec" {
    inline = [ 
      "echo 'hello world'> /tmp/hello.tx"
     ]
    
  }

  provisioner "file" {
    source = "./provider.tf"
    destination = "/tmp/"
    
  }

}

resource "aws_security_group" "instance" {

  name = "terraform-SG"
  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_key_pair" "key-tf1" {
  key_name   = "tf-key1"
  public_key = file("${path.module}/id_rsa.pub")

}


provider "aws" {
  region     = "ap-south-1"
      access_key = "XXXXXXXXXXXXXXXXXXXXX"
    secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx"

}
