resource "aws_security_group" "app" {
  name   = "${var.prefix_name}-${var.name}-app"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # demo-node.js
    from_port   = 3000
    to_port     = 3000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "ICMP"
    cidr_blocks = ["${aws_vpc.main.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.prefix_name}-${var.name}-app"
  }
}

resource "aws_security_group" "db" {
  name   = "${var.prefix_name}-${var.name}-db"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "TCP"
    security_groups = ["${aws_security_group.app.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.prefix_name}-${var.name}-db"
  }
}

resource "aws_security_group" "ssh" {
  name   = "${var.prefix_name}-${var.name}-ssh"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.prefix_name}-${var.name}-ssh"
  }
}

