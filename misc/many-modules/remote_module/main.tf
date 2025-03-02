# remote_module/main.tf

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with a valid AMI in your region
  instance_type = "t2.micro"  # Choose a cheap instance type

  tags = {
    Name = "ExampleInstance"
  }
}
