resource "aws_security_group" "lb_sg" {
  name   = "lb-${var.name}"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name      = "lb-${var.name}"
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "lb" {
  name            = "LB-${var.name}"
  subnets         = ["${var.lb_subnet_ids}"]
  security_groups = ["${aws_security_group.lb_sg.id}"]

  tags {
    Name      = "LB-${var.name}"
    Terraform = true
  }
}

resource "aws_lb_listener" "https" {
  count             = 0
  load_balancer_arn = "${aws_lb.lb.id}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.lb_cert_arn}"

  default_action {
    target_group_arn = "${var.target_group_id}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "default" {
  load_balancer_arn = "${aws_lb.lb.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "No content to display"
      status_code  = "200"
    }
  }
}
