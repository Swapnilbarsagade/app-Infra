resource "aws_instance" "example" {
  ami           = "ami-024ea438ab0376a47"
  instance_type = var.instance_type
  tags = {
    Name = "server"
  }
  vpc_security_group_ids = [aws_security_group.example.id]
}

resource "aws_security_group" "example" {
  name        = "example-security-group"
  description = "Allow HTTP traffic"
}

resource "aws_security_group_rule" "example" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.example.id
  cidr_blocks       = ["0.0.0.0/0"]

  depends_on = [aws_instance.example]
}