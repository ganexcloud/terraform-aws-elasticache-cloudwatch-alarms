variable "engine" {
  description = "ElastiCache engine. Redis enables Redis-only alarms; Memcached enables the Memcached byte-based memory alarm."
  type        = string

  validation {
    condition     = contains(["memcached", "redis"], var.engine)
    error_message = "engine must be either memcached or redis."
  }
}

variable "sns_topic_arn" {
  description = "A list of ARNs (for example, an SNS topic ARN) to notify on alerts."
  type        = list(string)
}

variable "alarm_name_prefix" {
  description = "Alarm name prefix."
  type        = string
  default     = ""
}

variable "id" {
  description = "Memcached cache cluster IDs. Set exactly one of id or cache_cluster_id."
  type        = list(string)
  default     = null
  nullable    = true
}

variable "cache_cluster_id" {
  description = "Redis cache cluster IDs. Set exactly one of cache_cluster_id or id."
  type        = list(string)
  default     = null
  nullable    = true
}

variable "cpu_utilization_threshold" {
  description = "The maximum percentage of CPU utilization."
  type        = number
  default     = 90
}

variable "engine_cpu_utilization_threshold" {
  description = "The maximum percentage of Engine CPU utilization (Redis only)."
  type        = number
  default     = 90
}

variable "currconnections_threshold" {
  description = "The maximum number of connections."
  type        = number
  default     = 4000
}

variable "memory_utilization_threshold" {
  description = "The maximum Redis memory utilization percentage. Retained for compatibility; not used for Memcached."
  type        = number
  default     = 90
}

variable "memcached_bytes_used_for_cache_items_threshold" {
  description = "The maximum Memcached BytesUsedForCacheItems value. Required when engine is memcached and the memory alarm is enabled."
  type        = number
  default     = null
  nullable    = true
}

variable "swap_usage_threshold" {
  description = "The maximum amount of swap space used on the cache node in bytes."
  type        = number
  default     = 256000000
}

variable "evictions_threshold" {
  description = "The maximum number of evictions in the alarm period."
  type        = number
  default     = 100
}

variable "network_bandwidth_out_allowance_exceeded_threshold" {
  description = "The maximum Redis network bandwidth out allowance exceeded value."
  type        = number
  default     = 300
}

variable "network_bandwidth_in_allowance_exceeded_threshold" {
  description = "The maximum Redis network bandwidth in allowance exceeded value."
  type        = number
  default     = 300
}

variable "cpu_utilization_too_high-alarm" {
  description = "Enable the CPU utilization alarm."
  type        = string
  default     = "true"
}

variable "cpu_utilization_too_high-comparison_operator" {
  description = "Comparison operator for the CPU utilization alarm."
  type        = string
  default     = "GreaterThanThreshold"
}

variable "cpu_utilization_too_high-datapoint" {
  description = "Evaluation periods for the CPU utilization alarm."
  type        = number
  default     = 1
}

variable "cpu_utilization_too_high-period" {
  description = "Period in seconds for the CPU utilization alarm."
  type        = number
  default     = 300
}

variable "engine_cpu_utilization_too_high-alarm" {
  description = "Enable the Redis EngineCPUUtilization alarm."
  type        = string
  default     = "true"
}

variable "engine_cpu_utilization_too_high-comparison_operator" {
  description = "Comparison operator for the Redis EngineCPUUtilization alarm."
  type        = string
  default     = "GreaterThanThreshold"
}

variable "engine_cpu_utilization_too_high-datapoint" {
  description = "Evaluation periods for the Redis EngineCPUUtilization alarm."
  type        = number
  default     = 1
}

variable "engine_cpu_utilization_too_high-period" {
  description = "Period in seconds for the Redis EngineCPUUtilization alarm."
  type        = number
  default     = 300
}

variable "currconnections_too_high-alarm" {
  description = "Enable the current connections alarm."
  type        = string
  default     = "true"
}

variable "currconnections_too_high-comparison_operator" {
  description = "Comparison operator for the current connections alarm."
  type        = string
  default     = "GreaterThanThreshold"
}

variable "currconnections_too_high-datapoint" {
  description = "Evaluation periods for the current connections alarm."
  type        = number
  default     = 1
}

variable "currconnections_too_high-period" {
  description = "Period in seconds for the current connections alarm."
  type        = number
  default     = 300
}

variable "memory_utilization_too_high-alarm" {
  description = "Enable the engine-specific memory alarm."
  type        = string
  default     = "true"
}

variable "memory_utilization_too_high-comparison_operator" {
  description = "Comparison operator for the engine-specific memory alarm."
  type        = string
  default     = "GreaterThanThreshold"
}

variable "memory_utilization_too_high-datapoint" {
  description = "Evaluation periods for the engine-specific memory alarm."
  type        = number
  default     = 1
}

variable "memory_utilization_too_high-period" {
  description = "Period in seconds for the engine-specific memory alarm."
  type        = number
  default     = 300
}

variable "swap_usage_too_high-alarm" {
  description = "Enable the SwapUsage alarm."
  type        = string
  default     = "true"
}

variable "swap_usage_too_high-comparison_operator" {
  description = "Comparison operator for the SwapUsage alarm."
  type        = string
  default     = "GreaterThanThreshold"
}

variable "swap_usage_too_high-datapoint" {
  description = "Evaluation periods for the SwapUsage alarm."
  type        = number
  default     = 1
}

variable "swap_usage_too_high-period" {
  description = "Period in seconds for the SwapUsage alarm."
  type        = number
  default     = 600
}

variable "evictions_too_high-alarm" {
  description = "Enable the Evictions alarm."
  type        = string
  default     = "true"
}

variable "evictions_too_high-comparison_operator" {
  description = "Comparison operator for the Evictions alarm."
  type        = string
  default     = "GreaterThanThreshold"
}

variable "evictions_too_high-datapoint" {
  description = "Evaluation periods for the Evictions alarm."
  type        = number
  default     = 1
}

variable "evictions_too_high-period" {
  description = "Period in seconds for the Evictions alarm."
  type        = number
  default     = 600
}

variable "network_bandwidth_out_allowance_exceeded-alarm" {
  description = "Enable the Redis network bandwidth out alarm."
  type        = string
  default     = "true"
}

variable "network_bandwidth_out_allowance_exceeded-comparison_operator" {
  description = "Comparison operator for the Redis network bandwidth out alarm."
  type        = string
  default     = "GreaterThanThreshold"
}

variable "network_bandwidth_out_allowance_exceeded-datapoint" {
  description = "Evaluation periods for the Redis network bandwidth out alarm."
  type        = number
  default     = 3
}

variable "network_bandwidth_out_allowance_exceeded-period" {
  description = "Period in seconds for the Redis network bandwidth out alarm."
  type        = number
  default     = 60
}

variable "network_bandwidth_in_allowance_exceeded-alarm" {
  description = "Enable the Redis network bandwidth in alarm."
  type        = string
  default     = "true"
}

variable "network_bandwidth_in_allowance_exceeded-comparison_operator" {
  description = "Comparison operator for the Redis network bandwidth in alarm."
  type        = string
  default     = "GreaterThanThreshold"
}

variable "network_bandwidth_in_allowance_exceeded-datapoint" {
  description = "Evaluation periods for the Redis network bandwidth in alarm."
  type        = number
  default     = 3
}

variable "network_bandwidth_in_allowance_exceeded-period" {
  description = "Period in seconds for the Redis network bandwidth in alarm."
  type        = number
  default     = 60
}

variable "tags" {
  description = "Optional tags to assign to all alarms."
  type        = map(string)
  default     = {}
}
