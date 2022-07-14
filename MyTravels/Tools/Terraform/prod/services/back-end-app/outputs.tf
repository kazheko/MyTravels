output "alb_dns_name" {
  value       = module.back_end.alb_dns_name
  description = "The domain name of the load balancer"
}