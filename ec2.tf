resource "aws_instance" "example" {
  ami           = "ami-012261b9035f8f938"
  instance_type = var.env == "prod" ? "t3.micro" : "t2.micro"
  vpc_security_group_ids = [
    aws_security_group.example_ec2.id
  ]

  tags = {
    Name = "example"
  }

  user_data = templatefile("${path.module}/user_data.sh.tpl", { package = "httpd" })
}

variable "env" {
  type    = string
  default = "dev"
}

output "example_instance_id" {
  value = aws_instance.example.id
}

output "example_public_dns" {
  value = aws_instance.example.public_dns
}

data "aws_iam_policy_document" "allow_describe_regions" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeRegions"]
    resources = ["*"]
  }
}

module "describe_regions_for_ec2" {
  source     = "./iam_role"
  name       = "describe-regions-for-ec2"
  policy     = data.aws_iam_policy_document.allow_describe_regions.json
  identifier = "ec2.amazonaws.com"
}
