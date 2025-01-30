provider "aws" {
  region = "us-east-1"  # CloudFront requires ACM in us-east-1
  profile = "swapnil"
  default_tags {
    tags = {
        Name = "aws"
        }
    }
}

variable "domain_name" {
  default = "swapnilbdevops.online"  # Change to your actual domain
}

variable "subdomain" {
  default = "www.example.com"  # Change to your subdomain if needed
}

# Create S3 Bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket = "my-static-website-bucket-123"  # Change to a globally unique name
}

# Enable Static Website Hosting
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Disable Public Access Blocking
resource "aws_s3_bucket_public_access_block" "disable_block" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket Policy for Public Read Access
resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}

# Get the AWS Certificate Manager (ACM) Certificate for CloudFront
data "aws_acm_certificate" "ssl_cert" {
  domain   = var.domain_name
  statuses = ["ISSUED"]
  most_recent = true
}

# Create CloudFront Distribution for HTTPS
resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id   = "S3Origin"

    s3_origin_config {
      origin_access_identity = ""
    }
  }

  enabled             = true
  default_root_object = "index.html"

  aliases = [var.subdomain]  # Custom domain

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.ssl_cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

# Route 53 DNS Record to Point Domain to CloudFront
resource "aws_route53_record" "cdn_record" {
  zone_id = data.aws_route53_zone.hosted_zone.id
  name    = var.subdomain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

# Fetch Route 53 Hosted Zone
data "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}
