# Changelog

## [Unreleased]

- Maintain engine-aware ElastiCache CloudWatch alarms.
- Correct Memcached `SwapUsage`, `Evictions`, and `BytesUsedForCacheItems` metrics.

## [1.0.0] - 2026-08-10

- Add engine-aware Memcached and Redis CloudWatch alarms behind the required `engine` input.
- Support `id` and `cache_cluster_id` cluster selectors with stable `count`-based alarm addresses.
- Correct Memcached `SwapUsage`, `Evictions` (`Sum`), and `BytesUsedForCacheItems` (`Average`) metrics.
- Require an explicit byte threshold for enabled Memcached memory alarms.

## [0.1.0] - 2026-08-10

- Initial public release.
