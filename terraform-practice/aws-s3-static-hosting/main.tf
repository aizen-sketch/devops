resource "aws_s3_bucket" "todo_app" {
  bucket = var.bucket_name
}


# Enable S3 static website hosting
resource "aws_s3_bucket_website_configuration" "todo_app" {
  bucket = aws_s3_bucket.todo_app.id

  index_document {
    suffix = "index.html"
  }
}


# Allow public access to the bucket
 resource "aws_s3_bucket_public_access_block" "todo_app" {
  bucket = aws_s3_bucket.todo_app.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}


# Allow anyone to read objects from the bucket
resource "aws_s3_bucket_policy" "todo_app" {
  bucket = aws_s3_bucket.todo_app.id

  depends_on = [
    aws_s3_bucket_public_access_block.todo_app
  ]

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "PublicReadGetObject"
        Effect = "Allow"

        Principal = "*"

        Action = "s3:GetObject"

        Resource = "${aws_s3_bucket.todo_app.arn}/*"
      }
    ]
  })
}


# Upload the Todo application
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.todo_app.id

  key    = "index.html"
  source = "../index.html"

  content_type = "text/html"

  # Re-upload whenever index.html changes
  etag = filemd5("../index.html")
}
