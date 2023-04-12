output "alb_target_group" {
    value = aws_lb_target_group.nlb_target_group.arn
}

output "network_load_balancer_dns_name" {
    value = aws_lb.network_load_balancer.dns_name
}

output "network_load_balancer_zone_id" {
    value = aws_lb.network_load_balancer.zone_id
}