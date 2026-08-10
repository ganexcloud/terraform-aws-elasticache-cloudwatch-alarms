terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40.0, < 7.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "redis_alarms" {
  source           = "../"
  engine           = "redis"
  cache_cluster_id = ["cache-a", "cache-b"]
  sns_topic_arn    = ["arn:aws:sns:us-east-1:123456789012:alerts"]
}
