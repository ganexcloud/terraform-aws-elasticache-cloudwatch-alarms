data "aws_iam_account_alias" "current" {}

locals {
  alarm_name_prefix = title(var.alarm_name_prefix == "" ? data.aws_iam_account_alias.current.account_alias : var.alarm_name_prefix)
  thresholds = {
    CPUUtilizationThreshold                       = min(max(var.cpu_utilization_threshold, 0), 100)
    EngineCPUUtilizationThreshold                 = min(max(var.engine_cpu_utilization_threshold, 0), 100)
    EvictionsThreshold                            = max(var.evictions_threshold, 0)
    CurrConnectionsThreshold                      = max(var.currconnections_threshold, 0)
    MemoryUtilizationThreshold                    = min(max(var.memory_utilization_threshold, 0), 100)
    SwapUsageThreshold                            = max(var.swap_usage_threshold, 0)
    NetworkBandwidthInAllowanceExceededThreshold  = max(var.network_bandwidth_in_allowance_exceeded_threshold, 0)
    NetworkBandwidthOutAllowanceExceededThreshold = max(var.network_bandwidth_out_allowance_exceeded_threshold, 0)
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_too_high" {
  count               = var.cpu_utilization_too_high-alarm == "true" ? length(var.cache_cluster_id) : 0
  alarm_name          = "[${title(local.alarm_name_prefix)}] elasticache-${element(var.cache_cluster_id, count.index)}-CPUUtilizationTooHigh"
  comparison_operator = var.cpu_utilization_too_high-comparison_operator
  evaluation_periods  = var.cpu_utilization_too_high-datapoint
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = var.cpu_utilization_too_high-period
  statistic           = "Average"
  threshold           = local.thresholds["CPUUtilizationThreshold"]
  alarm_description   = "Average CPU utilization over last ${var.cpu_utilization_too_high-period} seconds too high"
  alarm_actions       = var.sns_topic_arn
  ok_actions          = var.sns_topic_arn
  tags                = var.tags
  dimensions = {
    CacheClusterId = "${element(var.cache_cluster_id, count.index)}"
  }
}

resource "aws_cloudwatch_metric_alarm" "engine_cpu_utilization_too_high" {
  count               = var.engine_cpu_utilization_too_high-alarm == "true" ? length(var.cache_cluster_id) : 0
  alarm_name          = "[${title(local.alarm_name_prefix)}] elasticache-${element(var.cache_cluster_id, count.index)}-EngineCPUUtilizationTooHigh"
  comparison_operator = var.engine_cpu_utilization_too_high-comparison_operator
  evaluation_periods  = var.engine_cpu_utilization_too_high-datapoint
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = var.engine_cpu_utilization_too_high-period
  statistic           = "Average"
  threshold           = local.thresholds["EngineCPUUtilizationThreshold"]
  alarm_description   = "Average CPU utilization over last ${var.cpu_utilization_too_high-period} seconds too high"
  alarm_actions       = var.sns_topic_arn
  ok_actions          = var.sns_topic_arn
  tags                = var.tags
  dimensions = {
    CacheClusterId = "${element(var.cache_cluster_id, count.index)}"
  }
}

resource "aws_cloudwatch_metric_alarm" "currconnections_too_high" {
  count               = var.currconnections_too_high-alarm == "true" ? length(var.cache_cluster_id) : 0
  alarm_name          = "[${title(local.alarm_name_prefix)}] elasticache-${element(var.cache_cluster_id, count.index)}-CurrConnectionsTooHigh"
  comparison_operator = var.currconnections_too_high-comparison_operator
  evaluation_periods  = var.currconnections_too_high-datapoint
  metric_name         = "CurrConnections"
  namespace           = "AWS/ElastiCache"
  period              = var.currconnections_too_high-period
  statistic           = "Average"
  threshold           = local.thresholds["CurrConnectionsThreshold"]
  alarm_description   = "Average Current Connections have been greater than ${local.thresholds["CurrConnectionsThreshold"]} for at least ${var.currconnections_too_high-datapoint} seconds"
  alarm_actions       = var.sns_topic_arn
  ok_actions          = var.sns_topic_arn
  tags                = var.tags
  dimensions = {
    CacheClusterId = "${element(var.cache_cluster_id, count.index)}"
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_utilization_too_high" {
  count               = var.memory_utilization_too_high-alarm == "true" ? length(var.cache_cluster_id) : 0
  alarm_name          = "[${title(local.alarm_name_prefix)}] elasticache-${element(var.cache_cluster_id, count.index)}-MemoryUtilizationTooHigh"
  comparison_operator = var.memory_utilization_too_high-comparison_operator
  evaluation_periods  = var.memory_utilization_too_high-datapoint
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = var.memory_utilization_too_high-period
  statistic           = "Average"
  threshold           = local.thresholds["MemoryUtilizationThreshold"]
  alarm_description   = "Average Memory utilization over last ${var.memory_utilization_too_high-period} seconds too high"
  alarm_actions       = var.sns_topic_arn
  ok_actions          = var.sns_topic_arn
  tags                = var.tags
  dimensions = {
    CacheClusterId = "${element(var.cache_cluster_id, count.index)}"
  }
}

resource "aws_cloudwatch_metric_alarm" "swap_usage_too_high" {
  count               = var.memory_utilization_too_high-alarm == "true" ? length(var.cache_cluster_id) : 0
  alarm_name          = "[${title(local.alarm_name_prefix)}] elasticache-${element(var.cache_cluster_id, count.index)}-SwapUsageTooHigh"
  comparison_operator = var.swap_usage_too_high-comparison_operator
  evaluation_periods  = var.swap_usage_too_high-datapoint
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = var.swap_usage_too_high-period
  statistic           = "Average"
  threshold           = local.thresholds["SwapUsageThreshold"]
  alarm_description   = "Average Swap usage over last ${var.swap_usage_too_high-period} seconds too high"
  alarm_actions       = var.sns_topic_arn
  ok_actions          = var.sns_topic_arn
  tags                = var.tags
  dimensions = {
    CacheClusterId = "${element(var.cache_cluster_id, count.index)}"
  }
}

resource "aws_cloudwatch_metric_alarm" "evictions_too_high" {
  count               = var.evictions_too_high-alarm == "true" ? length(var.cache_cluster_id) : 0
  alarm_name          = "[${title(local.alarm_name_prefix)}] elasticache-${element(var.cache_cluster_id, count.index)}-EvictionsTooHigh"
  comparison_operator = var.evictions_too_high-comparison_operator
  evaluation_periods  = var.evictions_too_high-datapoint
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = var.evictions_too_high-period
  statistic           = "Average"
  threshold           = local.thresholds["EvictionsThreshold"]
  alarm_description   = "Average Evictions over last ${var.evictions_too_high-period} seconds too high"
  alarm_actions       = var.sns_topic_arn
  ok_actions          = var.sns_topic_arn
  tags                = var.tags
  dimensions = {
    CacheClusterId = "${element(var.cache_cluster_id, count.index)}"
  }
}

resource "aws_cloudwatch_metric_alarm" "network_bandwidth_out_allowance_exceeded" {
  count               = var.network_bandwidth_out_allowance_exceeded-alarm == "true" ? length(var.cache_cluster_id) : 0
  alarm_name          = "[${title(local.alarm_name_prefix)}] elasticache-${element(var.cache_cluster_id, count.index)}-NetworkBandwidthOutAllowanceExceeded"
  comparison_operator = var.network_bandwidth_out_allowance_exceeded-comparison_operator
  evaluation_periods  = var.network_bandwidth_out_allowance_exceeded-datapoint
  metric_name         = "NetworkBandwidthOutAllowanceExceeded"
  namespace           = "AWS/ElastiCache"
  period              = var.network_bandwidth_out_allowance_exceeded-period
  statistic           = "Average"
  threshold           = local.thresholds["NetworkBandwidthOutAllowanceExceededThreshold"]
  alarm_description   = "Average Network Out bandwidth exceeded over last ${var.network_bandwidth_out_allowance_exceeded-period} seconds too high"
  alarm_actions       = var.sns_topic_arn
  ok_actions          = var.sns_topic_arn
  tags                = var.tags
  dimensions = {
    CacheClusterId = "${element(var.cache_cluster_id, count.index)}"
  }
}

resource "aws_cloudwatch_metric_alarm" "network_bandwidth_in_allowance_exceeded" {
  count               = var.network_bandwidth_in_allowance_exceeded-alarm == "true" ? length(var.cache_cluster_id) : 0
  alarm_name          = "[${title(local.alarm_name_prefix)}] elasticache-${element(var.cache_cluster_id, count.index)}-NetworkBandwidthInAllowanceExceeded"
  comparison_operator = var.network_bandwidth_in_allowance_exceeded-comparison_operator
  evaluation_periods  = var.network_bandwidth_in_allowance_exceeded-datapoint
  metric_name         = "NetworkBandwidthInAllowanceExceeded"
  namespace           = "AWS/ElastiCache"
  period              = var.network_bandwidth_in_allowance_exceeded-period
  statistic           = "Average"
  threshold           = local.thresholds["NetworkBandwidthInAllowanceExceededThreshold"]
  alarm_description   = "Average Network In bandwidth exceeded over last ${var.network_bandwidth_in_allowance_exceeded-period} seconds too high"
  alarm_actions       = var.sns_topic_arn
  ok_actions          = var.sns_topic_arn
  tags                = var.tags
  dimensions = {
    CacheClusterId = "${element(var.cache_cluster_id, count.index)}"
  }
}
