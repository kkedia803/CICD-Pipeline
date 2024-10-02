provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "web" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name = "Terraform-EC2"
  }

  provisioner "file" {
    source      = "../public/index.html" # Local path to your HTML file
    destination = "/tmp/index.html"   # Destination on the EC2 instance

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = var.ssh_private_key # Adjust your private key path
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",                           # Update package lists
      "sudo apt-get install nginx -y",                    # Install Nginx
      "sudo systemctl start nginx",                       # Start Nginx
      "sudo systemctl enable nginx",                      # Enable Nginx to start on boot
      "sudo mv /tmp/index.html /var/www/html/index.html", # Move the HTML file to the correct directory
      "sudo systemctl restart nginx"                      # Restart Nginx to apply changes
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"                                              # Use 'ubuntu' as the username for Ubuntu instances
      private_key = var.ssh_private_key # Path to your private key
      host        = self.public_ip                                        # Connect to the instance's public IP
    }
  }
}

output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}