resource "aws_s3_bucket" "newsanju-12" {
    bucket = "newsanju-12" 
    acl = "private"   
}
resource "aws_s3_bucket_object" "object1" {
    for_each = fileset("uploads/", "*")
    bucket = aws_s3_bucket.newsanju-12.id
    key = each.value
    source = "uploads/${each.value}"
    etag = filemd5("uploads/${each.value}")
}


resource "aws_vpc" "myVpc" {
   cidr_block = "10.0.0.0/16"
 }

 resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.myVpc.id 
  cidr_block = "10.0.0.0/18"

     tags = {
       Name = "subnet"
    }
}
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.myVpc.id 
  cidr_block = "10.0.64.0/18"

     tags = {
       Name = "subnet"
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myVpc.id

  tags = {
    Name = "igw"
  }
}

# data "aws_nat_gateway" "new-natgateway" {
#   subnet_id = aws_subnet.public.id

#   tags = {
#     Name = "gw NAT"
#   }
# }



resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myVpc.id

  route = []
  tags = {
    Name = "example"
  }
}

resource "aws_route" "route" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on             = [aws_route_table.rt]
}

resource "aws_route_table_association" "a" {
   subnet_id      = aws_subnet.public.id
   route_table_id = aws_route_table.rt.id

 }
 resource "aws_route_table_association" "b" {
   subnet_id     = aws_subnet.private.id
   route_table_id = aws_route_table.rt.id
}

#  resource "aws_instance" "instance1" {
#   ami           = "ami-01f703c132f2b1a20" 
#   instance_type = "t2.micro"
#   subnet_id     = aws_subnet.public.id 
#   key_name = "demo"
#   tags = {
#     Name = "HelloWorld"
#   }
#  }

 resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.myVpc.id
  service_name = "com.amazonaws.us-west-2.s3"

  tags = {
    Environment = "test"
  }
}









################load blancer#############################
# resource "aws_lb_target_group" "my-target-group" {
#   health_check {
#     interval            = 10
#     path                = "/"
#     protocol            = "HTTP"
#     timeout             = 5
#     healthy_threshold   = 5
#     unhealthy_threshold = 2
#   }

#   name        = "my-test-tg"
#   port        = 80
#   protocol    = "HTTP"
#   target_type = "instance"
#   vpc_id      = "${var.vpc_id}"
# }

# resource "aws_lb_target_group_attachment" "my-alb-target-group-attachment1" {
#   target_group_arn = "${aws_lb_target_group.my-target-group.arn}"
#   target_id        = "${var.instance1_id}"
#   port             = 80
# }

# resource "aws_lb_target_group_attachment" "my-alb-target-group-attachment2" {
#   target_group_arn = "${aws_lb_target_group.my-target-group.arn}"
#   target_id        = "${var.instance2_id}"
#   port             = 80
# }

# resource "aws_lb" "my-aws-alb" {
#   name     = "my-test-alb"
#   internal = false

#   security_groups = [
#     "${aws_security_group.my-alb-sg.id}",
#   ]

#   subnets = [
#     "${var.subnet1}",
#     "${var.subnet2}",
#   ]

#   tags = {
#     Name = "my-test-alb"
#   }

#   ip_address_type    = "ipv4"
#   load_balancer_type = "application"
# }

# resource "aws_lb_listener" "my-test-alb-listner" {
#   load_balancer_arn = "${aws_lb.my-aws-alb.arn}"
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = "${aws_lb_target_group.my-target-group.arn}"
#   }
# }

# resource "aws_security_group" "my-alb-sg" {
#   name   = "my-alb-sg"
#   vpc_id = "${var.vpc_id}"
# }

# resource "aws_security_group_rule" "inbound_ssh" {
#   from_port         = 22
#   protocol          = "tcp"
#   security_group_id = "${aws_security_group.my-alb-sg.id}"
#   to_port           = 22
#   type              = "ingress"
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "inbound_http" {
#   from_port         = 80
#   protocol          = "tcp"
#   security_group_id = "${aws_security_group.my-alb-sg.id}"
#   to_port           = 80
#   type              = "ingress"
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "outbound_all" {
#   from_port         = 0
#   protocol          = "-1"
#   security_group_id = "${aws_security_group.my-alb-sg.id}"
#   to_port           = 0
#   type              = "egress"
#   cidr_blocks       = ["0.0.0.0/0"]
# }
