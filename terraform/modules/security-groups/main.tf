#backend alb security group
resource "aws_security_group" "backend-alb-sg" {
  name   = "backend-alb-sg"
  vpc_id = var.vpc_id


  ingress {
    description     = "traffic from frontend task"
    from_port       = 8081
    to_port         = 8081
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend-task-sg.id]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#frontend alb security group
resource "aws_security_group" "frontend-alb-sg" {
  name   = "frontend-alb-sg"
  vpc_id = var.vpc_id


  ingress {
    description = "traffic from everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "traffic from everywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#frontend task security group
resource "aws_security_group" "frontend-task-sg" {
  name   = "frontend-task-sg"
  vpc_id = var.vpc_id


  ingress {
    description     = "traffic from everywhere"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend-alb-sg.id]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocol's
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#backend task security group
resource "aws_security_group" "backend-task-sg" {
  name   = "backend-task-sg"
  vpc_id = var.vpc_id


  ingress {
    description     = "traffic from everywhere"
    from_port       = 8081
    to_port         = 8081
    protocol        = "tcp"
    security_groups = [aws_security_group.backend-alb-sg.id]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds-sg" {
  name   = "rds-sg"
  vpc_id = var.vpc_id

  ingress {
    description     = "traffic from backend tasks"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend-task-sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
