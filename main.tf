provider "aws" {
  profile = "default"
  region = "ca-central-1"  # Change this to your desired AWS region
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0a2e7efb4257c0907"  # Ubuntu 20.04 LTS
  instance_type = "t2.micro"

  tags = {
    Name = "my-ubuntu-instance"
  }

  user_data = <<-EOF
            
            sudo apt update
            sudo apt install nginx
            Y
            sudo ufw allow 'Nginx HTTP'
            sudo ufw enable
            y
            systemctl status nginx
            curl -4 icanhazip.com
            EOF

  vpc_security_group_ids = [aws_security_group.my_security_group.id]
}

resource "aws_security_group" "my_security_group" {
  name        = "allow-http-ingress"
  description = "Allow incoming traffic on port 80"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value = aws_instance.my_instance.public_ip
  
}

