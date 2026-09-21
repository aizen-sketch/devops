resource "aws_s3_bucket" "app" {
  bucket = var.bucket_name

  tags = {
    Name        = "todo-app-bucket"
    Environment = "dev"
  }
}
