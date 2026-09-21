output "website_url" {
  description = "URL of the Todo application"

  value = aws_s3_bucket_website_configuration.todo_app.website_endpoint
}