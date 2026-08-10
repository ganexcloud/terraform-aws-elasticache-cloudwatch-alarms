mock_provider "aws" {}

run "memcached_contract" {
  command = plan

  variables {
    engine                                         = "memcached"
    id                                             = ["cache-a", "cache-b"]
    sns_topic_arn                                  = ["arn:aws:sns:us-east-1:123456789012:alerts"]
    alarm_name_prefix                              = "ganex"
    memcached_bytes_used_for_cache_items_threshold = 900000000
  }

  assert {
    condition     = length(aws_cloudwatch_metric_alarm.cpu_utilization_too_high) == 2
    error_message = "Memcached CPU alarms must be created for both clusters."
  }

  assert {
    condition     = length(aws_cloudwatch_metric_alarm.engine_cpu_utilization_too_high) == 0
    error_message = "Redis-only EngineCPU alarms must not be created for Memcached."
  }

  assert {
    condition     = aws_cloudwatch_metric_alarm.memory_utilization_too_high[0].metric_name == "BytesUsedForCacheItems"
    error_message = "Memcached memory must use BytesUsedForCacheItems."
  }

  assert {
    condition     = aws_cloudwatch_metric_alarm.evictions_too_high[0].statistic == "Sum"
    error_message = "Memcached evictions must use Sum."
  }
}

run "redis_contract" {
  command = plan

  variables {
    engine            = "redis"
    cache_cluster_id  = ["cache-a", "cache-b"]
    sns_topic_arn     = ["arn:aws:sns:us-east-1:123456789012:alerts"]
    alarm_name_prefix = "ganex"
  }

  assert {
    condition     = length(aws_cloudwatch_metric_alarm.engine_cpu_utilization_too_high) == 2
    error_message = "Redis EngineCPU alarms must be created for both clusters."
  }

  assert {
    condition     = aws_cloudwatch_metric_alarm.memory_utilization_too_high[0].metric_name == "DatabaseMemoryUsagePercentage"
    error_message = "Redis memory must use DatabaseMemoryUsagePercentage."
  }
}

run "memcached_memory_threshold_required" {
  command = plan

  variables {
    engine        = "memcached"
    id            = ["cache-a"]
    sns_topic_arn = ["arn:aws:sns:us-east-1:123456789012:alerts"]
  }

  expect_failures = [
    aws_cloudwatch_metric_alarm.memory_utilization_too_high,
  ]
}
