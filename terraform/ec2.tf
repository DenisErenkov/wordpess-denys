resource "aws_security_group" "ec2_sg" {
  name        = "${var.name}-ec2-sg"
  description = "Allow HTTP,HTTPS, SSH"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.allowed_ports_ec2
    content {
      from_port   = tonumber(ingress.value)
      to_port     = tonumber(ingress.value)
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
   egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "wordpress" {
  ami           = "ami-034cf936557df396e" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]  
  key_name      = "denys.yerenkov" 
  tags = {
    Name = "${var.name}-WordPress EC2"
  }
}


resource "null_resource" "deploy_wordpress" {
  depends_on = [aws_instance.wordpress]
 
  provisioner "file" {
    source      = "./run.sh"  
    destination = "/tmp/run.sh"    
    connection {
      type        = "ssh"
      user        = "ubuntu"  
      private_key = file("./denys.yerenkov.pem")
      host        = aws_instance.wordpress.public_ip
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/run.sh",
      "/tmp/run.sh ${aws_db_instance.wordpress_db.db_name} ${aws_db_instance.wordpress_db.username} ${var.db_password} ${aws_db_instance.wordpress_db.endpoint} ${aws_elasticache_cluster.redis.cache_nodes[0].address} 6379"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu" 
      private_key = file("./denys.yerenkov.pem")
      host        = aws_instance.wordpress.public_ip
    }
  }
}



















