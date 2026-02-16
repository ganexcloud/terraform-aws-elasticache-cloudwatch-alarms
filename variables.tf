variable "sns_topic_arn" {
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on alerts"
  type        = list(string)
}

variable "alarm_name_prefix" {
  description = "Alarm name prefix"
  type        = string
  default     = ""
}

variable "cache_cluster_id" {
  description = "The instance ID of the Cache instances that you want to monitor."
  type        = list(string)
}

variable "cpu_utilization_threshold" {
  description = "The maximum percentage of CPU utilization."
  type        = number
  default     = 90
}

variable "engine_cpu_utilization_threshold" {
  description = "The maximum percentage of Engine CPU utilization."
  type        = number
  default     = 90
}

variable "currconnections_threshold" {
  description = "The maximum number of connections."
  type        = number
  default     = 4000
}

variable "memory_utilization_threshold" {
  description = "The maximum percentage of Memory utilization."
  type        = number
  default     = 90
}

variable "swap_usage_threshold" {
  description = "The maximum amount of swap space used on the DB instance in Byte."
  type        = number
  default     = 256000000
}

variable "evictions_threshold" {
  description = "The maximum number of evictions."
  type        = number
  default     = 100
}

variable "network_bandwidth_out_allowance_exceeded_threshold" {
  description = "The maximum bandwidth out exceeded."
  type        = number
  default     = 300
}

variable "network_bandwidth_in_allowance_exceeded_threshold" {
  description = "The maximum bandwidth in exceeded."
  type        = number
  default     = 300
}

variable "cpu_utilization_too_high-alarm" {
  description = "Enable Alarm to metric: cpu_utilization_too_high"
  default     = "true"
}

variable "cpu_utilization_too_high-comparison_operator" {
  description = "Comparison_operator to alarm"
  default     = "GreaterThanThreshold"
}

variable "cpu_utilization_too_high-datapoint" {
  description = "Datapoint check to alarm"
  default     = "1"
}

variable "cpu_utilization_too_high-period" {
  description = "Period check to alarm (in seconds)"
  default     = "300"
}

variable "engine_cpu_utilization_too_high-alarm" {
  description = "Enable Alarm to metric: engine_cpu_utilization_too_high"
  default     = "true"
}

variable "engine_cpu_utilization_too_high-comparison_operator" {
  description = "Comparison_operator to alarm"
  default     = "GreaterThanThreshold"
}

variable "engine_cpu_utilization_too_high-datapoint" {
  description = "Datapoint check to alarm"
  default     = "1"
}

variable "engine_cpu_utilization_too_high-period" {
  description = "Period check to alarm (in seconds)"
  default     = "300"
}

variable "currconnections_too_high-alarm" {
  description = "Enable Alarm to metric: cpu_utilization_too_high"
  default     = "true"
}

variable "currconnections_too_high-comparison_operator" {
  description = "Comparison_operator to alarm"
  default     = "GreaterThanThreshold"
}

variable "currconnections_too_high-datapoint" {
  description = "Datapoint check to alarm"
  default     = "1"
}

variable "currconnections_too_high-period" {
  description = "Period check to alarm (in seconds)"
  default     = "300"
}

variable "memory_utilization_too_high-alarm" {
  description = "Enable Alarm to metric: memory_utilization_too_high"
  default     = "true"
}

variable "memory_utilization_too_high-comparison_operator" {
  description = "Comparison_operator to alarm"
  default     = "GreaterThanThreshold"
}

variable "memory_utilization_too_high-datapoint" {
  description = "Datapoint check to alarm"
  default     = "1"
}

variable "memory_utilization_too_high-period" {
  description = "Period check to alarm (in seconds)"
  default     = "300"
}

variable "swap_usage_too_high-alarm" {
  description = "Enable Alaarm to metric: swap_usage_too_high"
  default     = "true"
}

variable "swap_usage_too_high-comparison_operator" {
  description = "Comparison_operator to alarm"
  default     = "GreaterThanThreshold"
}

variable "swap_usage_too_high-datapoint" {
  description = "Datapoint check to alarm"
  default     = "1"
}

variable "swap_usage_too_high-period" {
  description = "Period check to alarm (in seconds)"
  default     = "600"
}

variable "evictions_too_high-alarm" {
  description = "Enable Alaarm to metric: evictions_too_high"
  default     = "true"
}

variable "evictions_too_high-comparison_operator" {
  description = "Comparison_operator to alarm"
  default     = "GreaterThanThreshold"
}

variable "evictions_too_high-datapoint" {
  description = "Datapoint check to alarm"
  default     = "1"
}

variable "evictions_too_high-period" {
  description = "Period check to alarm (in seconds)"
  default     = "600"
}

variable "network_bandwidth_out_allowance_exceeded-alarm" {
  description = "Enable Alaarm to metric: network_bandwidth_out_allowance_exceeded"
  default     = "true"
}

variable "network_bandwidth_out_allowance_exceeded-comparison_operator" {
  description = "Comparison_operator to alarm"
  default     = "GreaterThanThreshold"
}

variable "network_bandwidth_out_allowance_exceeded-datapoint" {
  description = "Datapoint check to alarm"
  default     = "3"
}

variable "network_bandwidth_out_allowance_exceeded-period" {
  description = "Period check to alarm (in seconds)"
  default     = "60"
}

variable "network_bandwidth_in_allowance_exceeded-alarm" {
  description = "Enable Alaarm to metric: network_bandwidth_in_allowance_exceeded"
  default     = "true"
}

variable "network_bandwidth_in_allowance_exceeded-comparison_operator" {
  description = "Comparison_operator to alarm"
  default     = "GreaterThanThreshold"
}

variable "network_bandwidth_in_allowance_exceeded-datapoint" {
  description = "Datapoint check to alarm"
  default     = "3"
}

variable "network_bandwidth_in_allowance_exceeded-period" {
  description = "Period check to alarm (in seconds)"
  default     = "60"
}

variable "tags" {
  description = "(Optional) A map of tags to assign to the all resources"
  type        = map(string)
  default     = {}
}
