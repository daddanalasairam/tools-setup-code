terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
  }
}
resource "aws_security_group" "sg" {
  name        = "${var.component_name}-${var.env}-sg"
  description = "Inbound allow for ${var.component_name}"

  # inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # allow SSH from anywhere
  }

  ingress {
    from_port   = var.app_port #80
    to_port     = var.app_port #80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # allow HTTP from anywhere
  }

  # outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # all protocols
    cidr_blocks = ["0.0.0.0/0"]  # allow all outbound
  }
}


resource "aws_instance" "instance" {
  ami = data.aws_ami.ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = "${var.component_name}-${var.env}"
  }
}

#Terraform creates the SERVER. But the server is empty — no software installed.
#Provisioner = "after creating server, run these commands on it"
#remote-exec  =  Run commands ON the server (SSH into it)
#local-exec   =  Run commands on YOUR machine (where terraform runs)
resource "null_resource" "ansible-pull" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      password = "DevOps321"
      host        = aws_instance.instance.private_ip
    }

    inline = [
      "pip3 install ansible"
      "ansible-pull -i localhost, -U https://github.com/daddanalasairam/Roboshop-Ansible roboshop.yml -e env=${var.env} -e app_name=${var.component_name}"
    ]
  }
}

# provisioner "local_exec" {
#   command = <<EOL
#   cd /home/ec2-user/roboshop-ansible
#   command = "ansible-playbook -i ${self.private_ip}, -e ansible_user=ec2-user -e ansible_password=DevOps321 -e app_name=${var.component_name} -e env=${var.env} roboshop.yml"
#   EOL
# }

resource "aws_route53_record" "catalogue" {
  zone_id = "var.zone_id"
  name    = "${var.component_name}-${var.env}.${var.domain_name}"
  type    = "A"
  ttl     = "30"
  records = [aws_instance.instance.private_ip]
}

