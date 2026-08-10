# Migration sources

This repository consolidates the two legacy CloudWatch alarm modules without changing either source repository.

| Engine | Source | Branch | Baseline SHA |
| --- | --- | --- | --- |
| Memcached | https://gitlab.com/ganex-cloud/terraform/terraform-aws-elasticache-memcached-cloudwatch-alarms | `master` | `09cee6d8da030f8ba5fed67cc9087b952112286b` |
| Redis | https://gitlab.com/ganex-cloud/terraform/terraform-aws-elasticache-redis-cloudwatch-alarms | `master` | `d2ffdb33a96072041c903685ec7c5f067840964a` |

Both histories are present in the Git object database. The Redis history is connected through the baseline merge commit using the `ours` strategy; the consolidated root is implemented on the modernization branch and does not mix incompatible legacy roots.

The legacy GitLab projects remain unchanged and are not archived in this phase. Consumers, Terraform state, backends, and AWS accounts are explicitly out of scope.
