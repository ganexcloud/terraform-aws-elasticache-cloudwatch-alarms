# Elasticache
module "cloudwatch-alarms-elasticache_NAME" {
  source        = "git::https://gitlab.com/ganex-cloud/terraform/terraform-aws-elasticache-memcached-cloudwatch-alarms.git?ref=master"
  id            = module.NAME.id
  sns_topic_arn = ["${devops-topic_arn}"]
}
