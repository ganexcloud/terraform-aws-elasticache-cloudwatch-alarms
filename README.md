# terraform-aws-elasticache-cloudwatch-alarms

Creates standardized CloudWatch metric alarms for Amazon ElastiCache Redis and Memcached clusters.

## Usage

```hcl
module "elasticache_alarms" {
  source = "ganexcloud/elasticache-cloudwatch-alarms/aws"

  engine           = "redis"
  cache_cluster_id = ["cache-a", "cache-b"]
  sns_topic_arn    = [aws_sns_topic.alerts.arn]
}
```

Set `engine = "memcached"` and use the legacy `id` alias for Memcached consumers. Memcached memory alarms use `BytesUsedForCacheItems` and require `memcached_bytes_used_for_cache_items_threshold` in bytes. Redis-only Engine CPU and network bandwidth alarms are not created for Memcached.

The module keeps the legacy resource names and `count` indexing so a consumer can keep its module label while migrating. Set exactly one of `id` or `cache_cluster_id`; both aliases are accepted during the first consolidated release.

## Compatibility and release notes

This is a consolidated successor to the legacy Memcached and Redis modules. The Memcached Swap, Evictions, and memory alarms now use `SwapUsage`, `Evictions` with `Sum`, and `BytesUsedForCacheItems` respectively. The byte threshold is intentionally explicit; `memory_utilization_threshold` is not converted implicitly.

The Phase 1 plan, TODO, baselines, and evidence are preserved under [`docs/migration`](docs/migration/).

## Validation

```sh
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
terraform test
tflint --recursive
pre-commit run --all-files
```
