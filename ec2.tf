# Create EC2 Instance
# resource "aws_instance" "webapp_instance" {

#   depends_on = [
#     aws_security_group.application_security_group
#   ]
#   ami                         = var.ami_id
#   instance_type               = "t2.micro"
#   subnet_id                   = aws_subnet.public_subnets[0].id
#   security_groups             = [aws_security_group.application_security_group.id]
#   associate_public_ip_address = true
#   iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name

#   root_block_device {
#     volume_size           = 25
#     volume_type           = "gp2"
#     delete_on_termination = true
#   }

#   user_data = <<-EOF
#               #!/bin/bash
#               rm -f /opt/webapp/.env
#               touch /opt/webapp/.env
#               echo "DB_USER='${var.db_username}'" >> /opt/webapp/.env
#               echo "DB_PASSWORD='${var.db_password}'" >> /opt/webapp/.env
#               echo "DB_NAME='${var.db_name}'" >> /opt/webapp/.env
#               echo "PORT=${var.app_port}" >> /opt/webapp/.env
#               echo "DB_HOST='${aws_db_instance.rds_instance.address}'" >> /opt/webapp/.env
#               echo "S3_BUCKET_NAME='${aws_s3_bucket.csye6225_s3_bucket.bucket}'" >> /opt/webapp/.env
#               sudo systemctl restart webapp.service
#               /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start
#               sudo npm install -g statsd-cloudwatch-backend
#               statsd /opt/webapp/app/packer/statsd_config.js
#               EOF

#   tags = {
#     Name = "${var.vpc_name}-webapp-instance"
#   }

#   # Disable accidental termination protection
#   lifecycle {
#     prevent_destroy = false
#   }
# }
