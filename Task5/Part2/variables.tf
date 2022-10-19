# TODO: Define the variable for aws_region
variable "aws_east1" {
    description = "Defines AWS region"
    type = string
    default = "us-east-1"
}

variable "lambda_f_name" {
    description = "lambda function name"
    type = string
    default = "greet_lambda"   
}

variable "output_path" {
    description = "archive output path"
    type = string
    default = "greet_lambda.zip"
}

variable "py_source" {
    description = "Greet Lambda python"
    type = string
    default = "greet_lambda.py"
}