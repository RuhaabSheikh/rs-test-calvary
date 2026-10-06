resource "aws_s3_bucket" "test" {
  # Prefix rather than a fixed name: bucket names are global, so this avoids
  # collisions and keeps test/prod distinct.
  bucket_prefix = "rs-test-calvary-${var.environment}-"

  # Throwaway bucket: let destroy succeed even if objects were left in it.
  force_destroy = true
}

output "test_bucket_name" {
  value = aws_s3_bucket.test.id
}
