############################# BASTION
resource "aws_security_group" "bastion" {
  vpc_id      = var.vpc_id
  name_prefix = "Bastion server to access SSH"
  description = "Allow access to SSH from local machine bashion"

  ingress = [{
    cidr_blocks      = [local.allow_public_ip_cidr]
    description      = "SSH from my machine"
    from_port        = 22
    protocol         = "tcp"
    to_port          = 22
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false

  }]

  tags = {
    "Name" : "Bashion"
  }
}

############################# WEBSERVER
resource "aws_security_group" "webserver" {
  name_prefix = "Web server"
  description = "Webserver for internet access"
  vpc_id      = var.vpc_id

  # Can just ignore the ingress
  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Access from internet"
    from_port        = 80
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 80
    },

    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "Access from internet"
      from_port        = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 443
    },

  ]

  tags = {
    "Name" = "Webserver"
  }
}

############################ RDS DATABASE
resource "aws_security_group" "mysql" {
  vpc_id      = var.vpc_id
  name_prefix = "RDS MySql"
  description = "Allow to connect to RDS from bashion and  webserver to connect to"

  ingress = [{
    cidr_blocks      = [var.vpc_cidr]
    description      = "Access from bashion host and webserver"
    from_port        = 3306
    protocol         = "tcp"
    security_groups  = local.allow_from_web_and_bastion_sgs
    to_port          = 3306
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    self             = false
    }
  ]

  tags = {
    "Name" = "RDS MySQL"
  }
}

resource "aws_security_group" "postgresql" {
  vpc_id      = var.vpc_id
  name_prefix = "RDS Postgres"
  description = "Allow to connect to RDS from bashion and  webserver to connect to"

  ingress = [{
    cidr_blocks      = [var.vpc_cidr]
    description      = "Access from bashion host and webserver"
    from_port        = 5432
    protocol         = "tcp"
    security_groups  = local.allow_from_web_and_bastion_sgs
    to_port          = 5432
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    self             = false
    }
  ]

  tags = {
    "Name" = "RDS Postgresql"
  }
}

############################ Quicksight
# https://aws.amazon.com/premiumsupport/knowledge-center/quicksight-redshift-private-connection/
# link to the vpc with https://ap-southeast-1.quicksight.aws.amazon.com/sn/admin#vpc-connections

# In SG-123345678f Quicksight:

# Inbound:

# Type             Protocol          Port Range         Source                  Description
# ------------------------------------------------------------------------------------------------------------------
# All TCP           All              0 - 65535       sg-122887878f         Amazon RDS/Amazon Redshift security group
# Outbound:

# Type              Protocol          Port Range           Source                  Description
# ------------------------------------------------------------------------------------------------------------
# Custom TCP          TCP            5439 or 3306       sg-122887878f       Amazon RDS/Amazon Redshift security group

# In SG-122887878f RDS:

# Inbound:

# Type             Protocol          Port Range           Source                Description
# -----------------------------------------------------------------------------------------------------
# Custom TCP         TCP            5439 or 3306        sg-123345678f        QuickSight security group
# Outbound:

# Type            Protocol          Port Range          Source                  Description
# -------------------------------------------------------------------------------------------------
# All TCP           TCP             0 - 65535           sg-123345678f        QuickSight security group

# resource "aws_security_group" "quicksight" {
#   vpc_id      = var.vpc_id
#   name_prefix = "AWS Quicksight"
#   description = "Allow postgresql to be accessed by Quicksight"

#   ingress {
#     cidr_blocks      = ["0.0.0.0/0"]
#     description      = "Quicksight Singapore: ap-southeast-1"
#     from_port        = 0
#     protocol         = "-1"
#     to_port          = 0
#     # manually link this to avoid cycle dependency
#     # security_groups  = [aws_security_group.postgresql_replica.id]
#     ipv6_cidr_blocks = []
#     prefix_list_ids  = []
#     self             = false
#   }

#   egress {
#     cidr_blocks      = ["0.0.0.0/0"]
#     description      = ""
#     from_port        = 5432
#     ipv6_cidr_blocks = []
#     prefix_list_ids  = []
#     protocol         = "tcp"
#     # manually link this to avoid cycle dependency
#     # security_groups  = [ aws_security_group.postgresql_replica.id]
#     self             = false
#     to_port          = 5432
#   }


#   tags = {
#     "Name" = "RDS Quicksight"
#   }
# }

# resource "aws_security_group" "postgresql_replica" {
#   vpc_id      = var.vpc_id
#   name_prefix = "RDS Replica"
#   description = "Allow to connect to RDS from bashion, webserver and quicksight to connect to"

#   ingress {
#     cidr_blocks      = ["0.0.0.0/0"] #allow for quicksight and  + vpc
#     description      = "Access from bashion host, webserver and quicksight"
#     from_port        = 5432
#     protocol         = "tcp"
#     security_groups  = local.allow_from_web_bastion_and_qs_sgs
#     to_port          = 5432
#     ipv6_cidr_blocks = []
#     prefix_list_ids  = []
#     self             = false
#   }

#   egress {
#     cidr_blocks      = ["0.0.0.0/0"]
#     description      = ""
#     from_port        = 0
#     ipv6_cidr_blocks = []
#     prefix_list_ids  = []
#     protocol         = "-1"
#     security_groups  = [aws_security_group.quicksight.id]
#     self             = false
#     to_port          = 0
#   }

#   tags = {
#     "Name" = "RDS Replica"
#   }
# }

############################ REDIS
resource "aws_security_group" "redis" {
  vpc_id      = var.vpc_id
  name_prefix = "Security group for Redis"
  description = "Allow to connect to Redis from bashion and  webserver to connect to"

  ingress = [{
    cidr_blocks      = [var.vpc_cidr]
    description      = "Access from bashion host and webserver"
    from_port        = 6379
    protocol         = "tcp"
    security_groups  = local.allow_from_web_and_bastion_sgs
    to_port          = 6379
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    self             = false
    }
  ]

  tags = {
    "Name" = "Redis"
  }
}

############################ MEMCACHED
resource "aws_security_group" "memcached" {
  vpc_id      = var.vpc_id
  name_prefix = "Security group for Memchached"
  description = "Allow to connect to Memchached from bashion and  webserver to connect to"

  ingress = [{
    cidr_blocks      = [var.vpc_cidr]
    description      = "Access from bashion host and webserver"
    from_port        = 11211
    protocol         = "tcp"
    security_groups  = local.allow_from_web_and_bastion_sgs
    to_port          = 11211
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    self             = false
    }
  ]

  tags = {
    "Name" = "Memcached"
  }
}


############################ LOAD BALANCER
resource "aws_security_group" "load_balancer" {
  name_prefix = "Load banlancer application"
  description = "Control access from internet to ALB"
  vpc_id      = var.vpc_id

  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Anywhere"
    from_port        = 80
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 80
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "Anywhere"
      from_port        = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 443
  }]

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]

  tags = {
    "Name" = "Load Balancer"
  }
}

############################# ECS
resource "aws_security_group" "ecs" {
  name_prefix = "Ecs Security group"
  description = "Allow access from ABL to ECS"
  vpc_id      = var.vpc_id
  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow access from ALB to ECS"
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = [aws_security_group.load_balancer.id]
    self             = false
    to_port          = 0
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
  }]

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow access from SSH to ECS (in case of EC2)"
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]

  tags = {
    "Name" = "ECS"
  }
}
