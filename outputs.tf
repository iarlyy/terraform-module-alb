output "lb_arn_suffix" {
  value = "${aws_lb.lb.arn_suffix}"
}

output "http_listener_arn" {
  value = "${aws_lb_listener.default.arn}"
}
