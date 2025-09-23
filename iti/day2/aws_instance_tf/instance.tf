resource "aws_security_group" "jen_instance_sg" {
    vpc_id =                        aws_vpc.jen_vpc.id
    description =                   "Allow SSH Connection"
    ingress {
        from_port =                 var.ssh_port
        to_port =                   var.ssh_port
        protocol =                  "tcp"
        cidr_blocks =               ["0.0.0.0/0"]
    }

    tags = {
        Name=                       "Jenkins Agent Security Group"
    }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "jen_agent_instance" {
    subnet_id =                     aws_subnet.jen_subnet.id
    ami =                           data.aws_ami.ubuntu.id
    instance_type =                 "t3.micro"
    vpc_security_group_ids =        [aws_security_group.jen_instance_sg.id]

    key_name =                      "new-key"
    user_data = <<-EOF
        #!/bin/bash
        #create a jenkins user
        useradd jenkins -m -d /home/jenkins
        
        #install passwd utility
        apt-get update -y
        apt-get install -y passwd
        echo "jenkins:jenkins" | chpasswd

        #give the jenkins user a sudo privilige
        usermod -aG sudo jenkins

        echo "jenkins ALL=(ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/jenkins
        
        #allow plassword authentication for ssh
        sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
        EOF

    provisioner "local-exec" {
        #echo the instance public ip 
        command = "echo ${aws_instance.jen_agent_instance.public_ip} > ${path.cwd}/pub_ip.txt"

    }
    tags = {
        Name=                       "Jenkins Agent Instance"
    }
}