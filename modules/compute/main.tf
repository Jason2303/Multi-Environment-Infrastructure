resource "aws_security_group" "ssh" {
  name        = "${var.environment}-ssh"
  description = "Allow SSH connections"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${var.environment}"
  })
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4         = var.allowed_ssh_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "ssh" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_launch_template" "ec2_launch_template" {
  name_prefix   = "${var.environment}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair

  vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = merge(var.common_tags, {
    Name = "${var.environment}"
  })
}

resource "aws_autoscaling_group" "ec2_asg" {
  name                = "${var.environment}-asg"
  vpc_zone_identifier = var.private_subnet_id

  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }

  min_size         = var.asg_sizes.min_size
  max_size         = var.asg_sizes.max_size
  desired_capacity = var.asg_sizes.desired_capacity

  tag {
    key                 = "Name"
    value               = var.environment
    propagate_at_launch = true
  }
}