variable "email" { type = string }
variable "log_group_name" { type = string }
variable "sns_topic_name" { type = string }

### Variables provided per default by the Makefile
variable "account_id" {}
variable "env" {}
variable "plan_name" {}
variable "region" {}
variable "repository" {}
