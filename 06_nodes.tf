resource "aws_instance" "cluster_node" {
  count         = var.node_count
  ami           = data.aws_ami.devops_ubuntu.id
  instance_type = "t2.medium"
  tags = {
    Name = "${var.project_name}-node-${format("%02d", count.index + 1)}"
  }
  root_block_device {
    volume_size = "10"
  }
  key_name               = aws_key_pair.siimaarmaaV2.key_name
  subnet_id              = count.index % 2 == 0 ? data.aws_subnet.workshop_subnet_primary.id : data.aws_subnet.workshop_subnet_secondary.id
  vpc_security_group_ids = [data.aws_security_group.workshop_security_group.id]
  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("siimaarmaaV2.key")
  }
  provisioner "remote-exec" {
    inline = [
      "wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -",
      "sudo apt-get update",
      "sudo apt-get install apt-transport-https",
      "echo 'deb https://artifacts.elastic.co/packages/7.x/apt stable main' | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list",
      "sudo apt-get update && sudo apt-get install elasticsearch",
      "sudo chown -R elasticsearch:elasticsearch /usr/share/elasticsearch",
    ]
  }
}
