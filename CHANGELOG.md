# Changelog

## [Unreleased]

- Consolidate Memcached and Redis CloudWatch alarms behind one engine-aware module.
- Correct Memcached `SwapUsage`, `Evictions`, and `BytesUsedForCacheItems` metrics.

## [1.0.0] - 2026-08-10

- Consolidate the Memcached and Redis CloudWatch alarm modules behind the required `engine` input.
- Preserve the legacy `id` and `cache_cluster_id` aliases and `count`-based alarm addresses.
- Correct Memcached `SwapUsage`, `Evictions` (`Sum`), and `BytesUsedForCacheItems` (`Average`) metrics.
- Require an explicit byte threshold for enabled Memcached memory alarms.
- Release automation requires the consolidated contract's breaking-change footer before `v1.0.0`.

## [0.1.0] - 2026-08-10

- Preserve the Memcached and Redis source histories and migration evidence.
