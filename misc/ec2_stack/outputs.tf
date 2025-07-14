output "app_instance_id" {
  description = "ID of the application EC2 instance"
  value       = aws_autoscaling_group.app.id
}

output "app_instance_public_ip" {
  description = "Public IP address of the application EC2 instance"
  value       = "Access via load balancer"
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.app.name
}

output "autoscaling_group_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.app.arn
}

output "load_balancer_id" {
  description = "ID of the Application Load Balancer"
  value       = aws_lb.app.id
}

output "load_balancer_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app.dns_name
}

output "load_balancer_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.app.zone_id
}

output "target_group_arn" {
  description = "ARN of the Target Group"
  value       = aws_lb_target_group.app.arn
}

output "security_group_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.app_instances.id
}
