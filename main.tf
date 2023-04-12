
# CREATING INTERNAL LOAD BALANCER


resource "aws_lb" "internal_load_balancer" {
  name               = "${var.project_name}-ilb"
  internal           = true
  load_balancer_type = "network"
  subnets            = [var.private_subnet]

 enable_deletion_protection = false

   tags = {
    Environment = "non-production"
  }
}

# Creating target group
resource "aws_lb_target_group" "nlb_target_group" {

  name        = "${project_name}-tg"
  target_type = "ip"
  port        =  80
  protocol    = "HTTP
  vpc_id      = var.vpc_id


health_check {
  enabled             = true
  interval            = 300
  path                = "/"
  timeout             = 60
  matcher             = 200
  healthy_threshold   = 5
  unhealthy_threshold = 5

  }

  lifecycle {
   create_before_destroy = true
  }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "nlb_http_listener" {
  load_balancer_arn = aws_lb.netework_load_balancer.arn
  port              = 80
  protocol          = HTTP

  default_action {
    type = "redirect"
    
    redirect {
      port        = 3000
      protocol    = "HTTP"
      status_code = "HTTP_301"
    }
  }
}

# create a listener on port 443 with forward action

resource "aws_lb_listener" "nlb_https_listener" {

  load_balancer_arn  = aws_lb.network_load_balancer.arn 
  port               = 443
  protocol           = "HTTPS"
  ssl_policy         = "ELBSecurityPolicy-2016-08"
  certificate_arn    =  var.certificate_arn

  default_action {
    type             = "forword"
    target_group_arn = aws_lb_target_group.nlb_target_group.arn

  }
}




