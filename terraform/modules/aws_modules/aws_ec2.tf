data "template_file" "user_data_app" {
  template = "${file("${path.module}/templates/user_data_app.yml")}"

  vars {
    prefix_name      = "${var.prefix_name}"
    name             = "${var.name}"
    vpc_cidr         = "${var.vpc_cidr}"
    region           = "${var.region}"
    app_version      = "${var.app_version}"
  }
}

data "template_file" "user_data_db" {
  template = "${file("${path.module}/templates/user_data_db.yml")}"

  vars {
    prefix_name   = "${var.prefix_name}"
    name          = "${var.name}"
    vpc_cidr      = "${var.vpc_cidr}"
    region        = "${var.region}"
  }
}

resource "aws_iam_instance_profile" "instance_role" {
  name = "${var.prefix_name}-${var.name}-instance-role"
  role = "${aws_iam_role.instance_role.name}"
}

resource "aws_instance" "app" {
  ami                         = "${var.base_ami}"
  instance_type               = "${var.app_instance_type}"
  subnet_id                   = "${aws_subnet.a0.id}"
  availability_zone           = "ap-southeast-1a"
  associate_public_ip_address = true
  key_name                    = "${var.key_name}"
  user_data                   = "${data.template_file.user_data_app.rendered}"
  iam_instance_profile        = "${aws_iam_instance_profile.instance_role.id}"

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  vpc_security_group_ids = [
    "${aws_security_group.app.id}",
    "${aws_security_group.ssh.id}",
  ]

  tags {
    Name      = "${var.prefix_name}-${var.name}-app"
  }
}

resource "aws_instance" "db" {
  ami                         = "${var.base_ami}"
  instance_type               = "${var.db_instance_type}"
  subnet_id                   = "${aws_subnet.b0.id}"
  availability_zone           = "ap-southeast-1b"
  key_name                    = "${var.key_name}"
  user_data                   = "${data.template_file.user_data_db.rendered}"
  iam_instance_profile        = "${aws_iam_instance_profile.instance_role.id}"

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  vpc_security_group_ids = [
    "${aws_security_group.db.id}",
    "${aws_security_group.ssh.id}",
  ]

  tags {
    Name      = "${var.prefix_name}-${var.name}-db"
  }
}
