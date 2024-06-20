output "s3_bucket_name" {
  value = aws_s3_bucket.S3_App_bucket.id
}
output "s3_bucket_region" {
  value = aws_s3_bucket.S3_App_bucket.region
}
output "db_endpoint" {
  value = aws_db_instance.S3_App_DB.endpoint
}