resource "aws_instance" "example" {
  ami           = "ami-024ea438ab0376a47"
  instance_type = var.instance_type
  tags = {
    Name = "server"
  }
}


resource "aws_security_group_rule" "example" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = aws_instance.example.id

  depends_on = [aws_instance.example]
}