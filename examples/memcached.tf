module "memcached_alarms" {
  source                                         = "../"
  engine                                         = "memcached"
  id                                             = ["cache-a", "cache-b"]
  sns_topic_arn                                  = ["arn:aws:sns:us-east-1:123456789012:alerts"]
  memcached_bytes_used_for_cache_items_threshold = 900000000
}
