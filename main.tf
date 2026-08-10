locals {
  cluster_ids       = coalesce(var.cache_cluster_id, var.id, [])
  alarm_name_prefix = title(var.alarm_name_prefix)

  thresholds = {
    cpu              = min(max(var.cpu_utilization_threshold, 0), 100)
    engine_cpu       = min(max(var.engine_cpu_utilization_threshold, 0), 100)
    connections      = max(var.currconnections_threshold, 0)
    memory_redis     = min(max(var.memory_utilization_threshold, 0), 100)
    memory_memcached = max(coalesce(var.memcached_bytes_used_for_cache_items_threshold, 0), 0)
    swap             = max(var.swap_usage_threshold, 0)
    evictions        = max(var.evictions_threshold, 0)
    bandwidth_in     = max(var.network_bandwidth_in_allowance_exceeded_threshold, 0)
    bandwidth_out    = max(var.network_bandwidth_out_allowance_exceeded_threshold, 0)
  }

  aliases_valid = (var.cache_cluster_id != null) != (var.id != null)
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_too_high" {
  count               = var.cpu_utilization_too_high-alarm == "true" ? length(local.cluster_ids) : 0
  alarm_name          = "[${local.alarm_name_prefix}] elasticache-${local.cluster_ids[count.index]}-CPUUtilizationTooHigh"
  comparison_operator = var.cpu_utilization_too_high-comparison_operator
  evaluation_periods  = var.cpu_utilization_too_high-datapoint
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = var.cpu_utilization_too_high-period
  statistic           = "Average"
  threshold           = local.thresholds.cpu
  alarm_description   = "Average CPU utilization over last ${var.cpu_utilization_too_high-period} seconds too high"
  alarm_actions       = var.sns_topic_arn
  ok_actions          = var.sns_topic_arn
  tags                = var.tags
  dimensions          = { CacheClusterId = local.cluster_ids[count.index] }

  lifecycle {
    precondition {
      condition     = local.aliases_valid
      error_message = "Set exactly one of id or cache_cluster_id."
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "engine_cpu_utilization_too_high" {
  count               = var.engine == "redis" && var.engine_cpu_utilization_too_high-alarm == "true" ? length(local.cluster_ids) : 0
  alarm_name          = "[${local.alarm_name_prefix}] elasticache-${local.cluster_ids[count.index]}-EngineCPUUtilizationTooHigh"
  comparison_operator = var.engine_cpu_utilization_too_high-comparison_operator
  evaluation_periods  = var.engine_cpu_utilization_too_high-datapoint
  metric_name         = "EngineCPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = var.engine_cpu_utilization_too_high-period
  statistic           = "Average"
  threshold           = local.thresholds.engine_cpu
  alarm_description   = "Average engine CPU utilization over last ${var.engine_cpu_utilization_too_high-period} seconds too high"
  alarm_actions       = var.sns_topic_arn
  ok_actions          = var.sns_topic_arn
  tags                = var.tags
  dimensions          = { CacheClusterId = local.cluster_ids[count.index] }

  lifecycle {
    precondition {
      condition     = var.engine == "redis"
      error_message = "engine_cpu_utilization alarms are supported only when engine is redis."
    }
    precondition {
      condition     = local.aliases_valid
      error_message = "Set exactly one of id or cache_cluster_id."
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "currconnections_too_high" {
  count               = var.currconnections_too_high-alarm == "true" ? length(local.cluster_ids) : 0
  alarm_name          = "[${local.alarm_name_prefix}] elasticache-${local.cluster_ids[count.index]}-CurrConnectionsTooHigh"
  comparison_operator = var.currconnections_too_high-comparison_operator
  evaluation_periods  = var.currconnections_too_high-datapoint
  metric_name         = "CurrConnections"
  namespace           = "AWS/ElastiCache"
  period              = var.currconnections_too_high-period
  statistic           = "Average"
  threshold           = local.thresholds.connections
  alarm_description   = "Average Current Connections have been greater than ${local.thresholds.connections} for at least ${var.currconnections_too_high-datapoint} seconds"
  alarm_actions       = var.sns_topic_arn
  ok_actions          = var.sns_topic_arn
  tags                = var.tags
  dimensions          = { CacheClusterId = local.cluster_ids[count.index] }

  lifecycle {
    precondition {
      condition     = local.aliases_valid
      error_message = "Set exactly one of id or cache_cluster_id."
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_utilization_too_high" {
  count               = var.memory_utilization_too_high-alarm == "true" ? length(local.cluster_ids) : 0
  alarm_name          = "[${local.alarm_name_prefix}] elasticache-${local.cluster_ids[count.index]}-MemoryUtilizationTooHigh"
  comparison_operator = var.memory_utilization_too_high-comparison_operator
  evaluation_periods  = var.memory_utilization_too_high-datapoint
  metric_name         = var.engine == "memcached" ? "BytesUsedForCacheItems" : "DatabaseMemoryUsagePercentage"
  namespace           = "AWS/ElastiCache"
  period              = var.memory_utilization_too_high-period
  statistic           = "Average"
  threshold           = var.engine == "memcached" ? local.thresholds.memory_memcached : local.thresholds.memory_redis
  alarm_description   = var.engine == "memcached" ? "Average bytes used for cache items over last ${var.memory_utilization_too_high-period} seconds too high" : "Average Redis memory utilization over last ${var.memory_utilization_too_high-period} seconds too high"
  alarm_actions       = var.sns_topic_arn
  ok_actions          = var.sns_topic_arn
  tags                = var.tags
  dimensions          = { CacheClusterId = local.cluster_ids[count.index] }

  lifecycle {
    precondition {
      condition     = local.aliases_valid
      error_message = "Set exactly one of id or cache_cluster_id."
    }
    precondition {
      condition     = var.engine != "memcached" || var.memcached_bytes_used_for_cache_items_threshold != null
      error_message = "memcached_bytes_used_for_cache_items_threshold is required when engine is memcached and the memory alarm is enabled."
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "swap_usage_too_high" {
  count               = var.swap_usage_too_high-alarm == "true" ? length(local.cluster_ids) : 0
  alarm_name          = "[${local.alarm_name_prefix}] elasticache-${local.cluster_ids[count.index]}-SwapUsageTooHigh"
  comparison_operator = var.swap_usage_too_high-comparison_operator
  evaluation_periods  = var.swap_usage_too_high-datapoint
  metric_name         = "SwapUsage"
  namespace           = "AWS/ElastiCache"
  period              = var.swap_usage_too_high-period
  statistic           = "Average"
  threshold           = local.thresholds.swap
  alarm_description   = "Average Swap usage over last ${var.swap_usage_too_high-period} seconds too high"
  alarm_actions       = var.sns_topic_arn
  ok_actions          = var.sns_topic_arn
  tags                = var.tags
  dimensions          = { CacheClusterId = local.cluster_ids[count.index] }

  lifecycle {
    precondition {
      condition     = local.aliases_valid
      error_message = "Set exactly one of id or cache_cluster_id."
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "evictions_too_high" {
  count               = var.evictions_too_high-alarm == "true" ? length(local.cluster_ids) : 0
  alarm_name          = "[${local.alarm_name_prefix}] elasticache-${local.cluster_ids[count.index]}-EvictionsTooHigh"
  comparison_operator = var.evictions_too_high-comparison_operator
  evaluation_periods  = var.evictions_too_high-datapoint
  metric_name         = "Evictions"
  namespace           = "AWS/ElastiCache"
  period              = var.evictions_too_high-period
  statistic           = "Sum"
  threshold           = local.thresholds.evictions
  alarm_description   = "Sum of evictions over last ${var.evictions_too_high-period} seconds too high"
  alarm_actions       = var.sns_topic_arn
  ok_actions          = var.sns_topic_arn
  tags                = var.tags
  dimensions          = { CacheClusterId = local.cluster_ids[count.index] }

  lifecycle {
    precondition {
      condition     = local.aliases_valid
      error_message = "Set exactly one of id or cache_cluster_id."
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "network_bandwidth_out_allowance_exceeded" {
  count               = var.engine == "redis" && var.network_bandwidth_out_allowance_exceeded-alarm == "true" ? length(local.cluster_ids) : 0
  alarm_name          = "[${local.alarm_name_prefix}] elasticache-${local.cluster_ids[count.index]}-NetworkBandwidthOutAllowanceExceeded"
  comparison_operator = var.network_bandwidth_out_allowance_exceeded-comparison_operator
  evaluation_periods  = var.network_bandwidth_out_allowance_exceeded-datapoint
  metric_name         = "NetworkBandwidthOutAllowanceExceeded"
  namespace           = "AWS/ElastiCache"
  period              = var.network_bandwidth_out_allowance_exceeded-period
  statistic           = "Average"
  threshold           = local.thresholds.bandwidth_out
  alarm_description   = "Average Network Out bandwidth exceeded over last ${var.network_bandwidth_out_allowance_exceeded-period} seconds too high"
  alarm_actions       = var.sns_topic_arn
  ok_actions          = var.sns_topic_arn
  tags                = var.tags
  dimensions          = { CacheClusterId = local.cluster_ids[count.index] }

  lifecycle {
    precondition {
      condition     = var.engine == "redis"
      error_message = "network bandwidth alarms are supported only when engine is redis."
    }
    precondition {
      condition     = local.aliases_valid
      error_message = "Set exactly one of id or cache_cluster_id."
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "network_bandwidth_in_allowance_exceeded" {
  count               = var.engine == "redis" && var.network_bandwidth_in_allowance_exceeded-alarm == "true" ? length(local.cluster_ids) : 0
  alarm_name          = "[${local.alarm_name_prefix}] elasticache-${local.cluster_ids[count.index]}-NetworkBandwidthInAllowanceExceeded"
  comparison_operator = var.network_bandwidth_in_allowance_exceeded-comparison_operator
  evaluation_periods  = var.network_bandwidth_in_allowance_exceeded-datapoint
  metric_name         = "NetworkBandwidthInAllowanceExceeded"
  namespace           = "AWS/ElastiCache"
  period              = var.network_bandwidth_in_allowance_exceeded-period
  statistic           = "Average"
  threshold           = local.thresholds.bandwidth_in
  alarm_description   = "Average Network In bandwidth exceeded over last ${var.network_bandwidth_in_allowance_exceeded-period} seconds too high"
  alarm_actions       = var.sns_topic_arn
  ok_actions          = var.sns_topic_arn
  tags                = var.tags
  dimensions          = { CacheClusterId = local.cluster_ids[count.index] }

  lifecycle {
    precondition {
      condition     = var.engine == "redis"
      error_message = "network bandwidth alarms are supported only when engine is redis."
    }
    precondition {
      condition     = local.aliases_valid
      error_message = "Set exactly one of id or cache_cluster_id."
    }
  }
}
