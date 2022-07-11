output "alb_dns_name" {
 value = aws_lb.lb.dns_name
 description = "The domain name of the load balancer"
}

output "alb_http_listener_arn" {
  value       = aws_alb_listener.http_listener.arn
  description = "The ARN of the HTTP listener"
}