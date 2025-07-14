/*
  EC2 Stack
  
  This module creates a production-ready EC2 setup with the following features:
  - Auto Scaling Group for high availability and scalability
  - Application Load Balancer for traffic distribution
  - Custom AMI with hardened security configurations
  - IAM roles with least privilege principle
  - CloudWatch alarms for monitoring
  - EC2 instance profile for secure AWS service access
  - User data script for application bootstrap
*/

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security group for EC2 instances
resource "aws_security_group" "app_instances" {
  name        = "${var.project_name}-${var.environment}-app-sg"
  description = "Security group for application instances"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    description     = "Allow HTTP from ALB"
  }
  
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    description     = "Allow HTTPS from ALB"
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidr_blocks
    description = "Allow SSH from allowed CIDR blocks"
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  
  tags = {
    Name = "${var.project_name}-${var.environment}-app-sg"
  }
}

# Security group for Application Load Balancer
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Security group for application load balancer"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere"
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  
  tags = {
    Name = "${var.project_name}-${var.environment}-alb-sg"
  }
}

# IAM role for EC2 instances
resource "aws_iam_role" "app_instance" {
  name = "${var.project_name}-${var.environment}-app-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  
  tags = {
    Name = "${var.project_name}-${var.environment}-app-role"
  }
}

# IAM policy for S3 access
resource "aws_iam_policy" "s3_access" {
  name        = "${var.project_name}-${var.environment}-s3-access-policy"
  description = "Policy for accessing application S3 bucket"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      }
    ]
  })
}

# Attach S3 access policy to IAM role
resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.app_instance.name
  policy_arn = aws_iam_policy.s3_access.arn
}

# Attach SSM managed policy to IAM role for system management
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.app_instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# EC2 instance profile
resource "aws_iam_instance_profile" "app" {
  name = "${var.project_name}-${var.environment}-app-profile"
  role = aws_iam_role.app_instance.name
}

# Launch template for EC2 instances
resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-${var.environment}-app-lt-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  
  iam_instance_profile {
    name = aws_iam_instance_profile.app.name
  }
  
  vpc_security_group_ids = [aws_security_group.app_instances.id]
  
  monitoring {
    enabled = var.enable_monitoring
  }
  
  block_device_mappings {
    device_name = "/dev/xvda"
    
    ebs {
      volume_size           = var.root_volume_size
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }
  
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"  # IMDSv2 for enhanced security
    http_put_response_hop_limit = 1
  }
  
  user_data = base64encode(<<-EOF
    #!/bin/bash
    
    # Update system packages
    yum update -y
    
    # Install necessary packages
    yum install -y amazon-cloudwatch-agent httpd jq
    
    # Start and enable Apache web server
    systemctl start httpd
    systemctl enable httpd
    
    # Configure AWS CLI and region
    echo "AWS_REGION=${var.aws_region}" > /etc/environment
    
    # Create application directory
    mkdir -p /var/www/html/app
    
    # Create a sample index page
    cat > /var/www/html/index.html << 'EOL'
    <!DOCTYPE html>
    <html>
    <head>
      <title>${var.project_name} - ${var.environment}</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          max-width: 800px;
          margin: 0 auto;
          padding: 20px;
          text-align: center;
        }
        .container {
          background-color: #f9f9f9;
          border-radius: 10px;
          padding: 20px;
          margin-top: 50px;
          box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
      </style>
    </head>
    <body>
      <div class="container">
        <h1>${var.project_name} - ${var.environment}</h1>
        <p>Application running on Amazon EC2</p>
        <p>Instance ID: <span id="instance-id">Loading...</span></p>
        <p>Availability Zone: <span id="az">Loading...</span></p>
      </div>
      <script>
        fetch('http://169.254.169.254/latest/api/token', {
          method: 'PUT',
          headers: {
            'X-aws-ec2-metadata-token-ttl-seconds': '21600'
          }
        })
        .then(response => response.text())
        .then(token => {
          fetch('http://169.254.169.254/latest/meta-data/instance-id', {
            headers: {
              'X-aws-ec2-metadata-token': token
            }
          })
          .then(response => response.text())
          .then(instanceId => {
            document.getElementById('instance-id').textContent = instanceId;
          });
          
          fetch('http://169.254.169.254/latest/meta-data/placement/availability-zone', {
            headers: {
              'X-aws-ec2-metadata-token': token
            }
          })
          .then(response => response.text())
          .then(az => {
            document.getElementById('az').textContent = az;
          });
        });
      </script>
    </body>
    </html>
    EOL
    
    # Configure CloudWatch Agent
    cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'EOL'
    {
      "metrics": {
        "append_dimensions": {
          "AutoScalingGroupName": "${aws:AutoScalingGroupName}",
          "ImageId": "${aws:ImageId}",
          "InstanceId": "${aws:InstanceId}",
          "InstanceType": "${aws:InstanceType}"
        },
        "metrics_collected": {
          "mem": {
            "measurement": ["mem_used_percent"],
            "metrics_collection_interval": 60
          },
          "disk": {
            "measurement": ["disk_used_percent"],
            "metrics_collection_interval": 60,
            "resources": ["*"]
          }
        }
      },
      "logs": {
        "logs_collected": {
          "files": {
            "collect_list": [
              {
                "file_path": "/var/log/httpd/access_log",
                "log_group_name": "/${var.project_name}/${var.environment}/httpd/access_log",
                "log_stream_name": "{instance_id}"
              },
              {
                "file_path": "/var/log/httpd/error_log",
                "log_group_name": "/${var.project_name}/${var.environment}/httpd/error_log",
                "log_stream_name": "{instance_id}"
              }
            ]
          }
        }
      }
    }
    EOL
    
    # Start CloudWatch Agent
    systemctl start amazon-cloudwatch-agent
    systemctl enable amazon-cloudwatch-agent
    
    # Tag instance with startup time
    INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $(curl -s -X PUT http://169.254.169.254/latest/api/token -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")" http://169.254.169.254/latest/meta-data/instance-id)
    aws ec2 create-tags --resources $INSTANCE_ID --tags Key=StartupTime,Value=$(date -Iseconds) --region ${var.aws_region}
    
    echo "Initialization complete"
  EOF
  )
  
  tag_specifications {
    resource_type = "instance"
    
    tags = {
      Name        = "${var.project_name}-${var.environment}-app"
      Environment = var.environment
      ManagedBy   = "OpenTofu"
    }
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

# Application Load Balancer
resource "aws_lb" "app" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.environment == "prod" ? true : false
  
  access_logs {
    bucket  = var.s3_bucket_name
    prefix  = "alb-logs"
    enabled = true
  }
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-alb"
    Environment = var.environment
  }
}

# ALB target group
resource "aws_lb_target_group" "app" {
  name     = "${var.project_name}-${var.environment}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  
  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-tg"
    Environment = var.environment
  }
}

# ALB listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app" {
  name_prefix               = "${var.project_name}-${var.environment}-asg-"
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  desired_capacity          = var.asg_desired_capacity
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = var.subnet_ids
  target_group_arns         = [aws_lb_target_group.app.arn]
  
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
  
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]
  
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 90
      instance_warmup        = 300
    }
  }
  
  lifecycle {
    create_before_destroy = true
  }
  
  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-app"
    propagate_at_launch = true
  }
  
  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
  
  tag {
    key                 = "ManagedBy"
    value               = "OpenTofu"
    propagate_at_launch = true
  }
}

# Auto scaling policies
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.project_name}-${var.environment}-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.project_name}-${var.environment}-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app.name
}

# CloudWatch alarms for auto scaling
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-${var.environment}-high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric triggers when CPU exceeds 70% for 10 minutes"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "${var.project_name}-${var.environment}-low-cpu"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "30"
  alarm_description   = "This metric triggers when CPU is below 30% for 10 minutes"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "app" {
  dashboard_name = "${var.project_name}-${var.environment}-dashboard"
  
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", aws_autoscaling_group.app.name]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "ASG CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.app.arn_suffix]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "ALB Request Count"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", aws_lb.app.arn_suffix]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "ALB Response Time"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            [
              "AWS/ApplicationELB",
              "HTTPCode_Target_2XX_Count",
              "LoadBalancer", 
              aws_lb.app.arn_suffix
            ],
            [
              "AWS/ApplicationELB",
              "HTTPCode_Target_4XX_Count",
              "LoadBalancer", 
              aws_lb.app.arn_suffix
            ],
            [
              "AWS/ApplicationELB",
              "HTTPCode_Target_5XX_Count",
              "LoadBalancer", 
              aws_lb.app.arn_suffix
            ]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "ALB Response Codes"
        }
      }
    ]
  })
}
