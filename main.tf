provider "aws" {
   region = "us-east-2" 
}

# TODO: Add Alarms to warn in case I forgot to turn this off
resource "aws_instance" "example" {
  
  # EXPENSIVE!!! MAKE SURE YOU DESTROY
  # Deep Learning AMI (Ubuntu 18.04) Version ??.?
  # used this guide: https://docs.aws.amazon.com/dlami/latest/devguide/launch.html
  ami               = "ami-0ea67df30b19db68e"
  instance_type          = "g3s.xlarge"
  
  # # free tier testing
  # ami               = "ami-0fb653ca2d3203ac1"
  # instance_type          = "t2.micro"
  key_name               = "aws_key"
  vpc_security_group_ids = [aws_security_group.main.id]

  provisioner "file" {
    source      = "jupyter_config.py"
    destination = "/home/ubuntu/.jupyter/jupyter_notebook_config.py"
  }


  # TODO: write a script to generate jupyter config
  # most likely not in this file but adding this comment
  # here as I'm not sure where else to put it
  provisioner "remote-exec" {
    inline = [
      "touch hello.txt",
      "mkdir ssl",
      "cd ssl",
      "openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout \"cert.key\" -out \"cert.pem\" -batch",
      "cd $HOME",
      "sudo pip install keras --upgrade",
      "sudo pip install tensorflow",
      "git clone https://github.com/fchollet/deep-learning-with-python-notebooks.git",
    ]
  }
  # I used "~ ssh-keygen -t rsa -b 2048" to make keys
  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      # TODO: consider using relative path
      private_key = file("/Users/alek.binion/study/deep-learning-with-python/workspace/aws_key")
      timeout     = "4m"
   }
}

resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  },
  {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 8888
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 8888
  }
  ]
}


resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = file("/Users/alek.binion/study/deep-learning-with-python/workspace/aws_key.pub")
}

output "ec2_ssh_command" {
  value = "ssh -i aws_key ubuntu@${aws_instance.example.public_ip}"
}

output "ec2_port_forwarding" {
  value = "sudo ssh -i aws_key -L 443:127.0.0.1:8888 ubuntu@${aws_instance.example.public_ip}"
}

output "set_var" {
  value = "NOTEBOOK_IP=${aws_instance.example.public_ip}"
}
