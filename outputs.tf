# Sample outputs for exercising the tofu-output-summary action. Each one
# targets a different branch of its rendering.

# --- Real values from the bucket ---

# output "bucket_arn" {
#   value = aws_s3_bucket.test.arn
# }

# output "bucket_regional_domain_name" {
#   value = aws_s3_bucket.test.bucket_regional_domain_name
# }

# output "bucket_tags" {
#   value = aws_s3_bucket.test.tags_all
# }

# --- Scalar types ---

output "plain_string" {
  value = "hello-${var.environment}"
}

output "number_value" {
  value = 42
}

output "float_value" {
  value = 3.14159
}

output "bool_value" {
  value = true
}

output "null_value" {
  value = null
}

output "empty_string" {
  value = ""
}

# --- Collection types (rendered via tojson) ---

output "list_of_strings" {
  value = ["alpha", "beta", "gamma"]
}

output "empty_list" {
  value = []
}

output "map_value" {
  value = {
    region      = var.aws_region
    environment = var.environment
  }
}

output "nested_object" {
  value = {
    name    = "nested"
    enabled = false
    ports   = [80, 443]
    limits = {
      cpu    = "500m"
      memory = "1Gi"
    }
  }
}

# --- Characters the Markdown table needs to escape ---

output "string_with_pipes" {
  value = "a | b | c"
}

output "multiline_string" {
  value = <<-EOT
    line one
    line two
    line three
  EOT
}

output "string_with_backticks" {
  value = "run `tofu apply` first"
}

output "string_with_markdown" {
  value = "**bold** _italic_ <b>html</b> [link](https://example.com)"
}

output "long_string" {
  value = join("-", [for i in range(40) : "segment${i}"])
}

output "unicode_string" {
  value = "café — ✓ 日本語"
}

# --- Sensitive (should render as "(sensitive)") ---

output "sensitive_string" {
  value     = "super-secret-value"
  sensitive = true
}

output "sensitive_map" {
  value = {
    username = "admin"
    password = "hunter2"
  }
  sensitive = true
}

# --- Complex nested outputs, shaped like a real platform stack ---
# Random placeholder values (not real IDs); the repeated
# per-app structures are generated with for expressions.

locals {
  acct      = "187610623698"
  edge_acct = "431963641829"
  region    = "ap-southeast-2"
  domain    = "np-9gjg1o.aws.example.net"
  apps      = ["chat", "notes", "portal"]
  tiers     = { "be" = "back-end", "fe" = "front-end" }

  # Random resource IDs, keyed by what they identify.
  rand = {
    rest_api_id     = "a7nvtqecf7"
    api_key_id      = "kvu082kp1b"
    usage_plan_id   = "9xaxwm"
    guardrail_id    = "tji5o5xb4fxp"
    guardrail_ver   = "6"
    opensearch_hash = "nysnzyd6tpk2izmc0z0wr61e4f"
    hosted_zone_id  = "ZGX9DPGKI6ELO1"
    edge_alb_id     = "5b0f1daf60a0e263"
    edge_dns_id     = "517191124"
    edge_listener   = "2214c9826b370076"
    task_revision   = "5"
  }

  edge_rule_ids = {
    "chat"      = "e5cd9f7855eabcb3"
    "chat-be"   = "dcef37b6cb54b993"
    "notes"     = "0a68acb97efefe4a"
    "notes-be"  = "5003c8bae0d06bba"
    "portal"    = "b1b39cd77ede3332"
    "portal-be" = "c5253c0733fce77e"
  }
  edge_tg_ids = {
    "8081" = "4be8157451dacad8"
    "8082" = "9ac5a461ee943a85"
    "8083" = "84c769c2efe44773"
    "8181" = "7f0720ecafaaea21"
    "8182" = "692ef7ffc5a1df0e"
    "8183" = "499e2a3d08db3165"
  }

  # Internal NLB per tier.
  lb_ids = {
    fe = {
      "lb" = "fe03d44abd7bd078"
      "listeners" = {
        "chat"   = "0a252e429269242c"
        "notes"  = "89e22a6a5a9d07d4"
        "portal" = "c173ba52446a2b73"
      }
      "tg_names" = {
        "chat"   = "o61dfup35c8wwew5i08yv3bvj5"
        "notes"  = "0g0b8gdqfots69kghtjvodvbk3"
        "portal" = "7bisyz5m80e1muknzz3mozxuec"
      }
      "tg_ids" = {
        "chat"   = "4e9fa9abc8af4914"
        "notes"  = "f853d955d1163253"
        "portal" = "7049b3ed9ddad80f"
      }
    }
    be = {
      "lb" = "87048a47d288f7ce"
      "listeners" = {
        "chat"   = "3cb607bf20ddf472"
        "notes"  = "289ba525b7d992af"
        "portal" = "a8c5dbbb730ba14d"
      }
      "tg_names" = {
        "chat"   = "wtjgukl6lejzirwos2ghctwp1z"
        "notes"  = "3g2mo9wqzzvkyqxvza1dultwb3"
        "portal" = "gyeuf0erxoxeoeje98im35gwvp"
      }
      "tg_ids" = {
        "chat"   = "24f53f34c2cbb896"
        "notes"  = "2881ce87bb403d57"
        "portal" = "92f75ecd84826c85"
      }
    }
  }


  edge_dns     = "cal-o-alb-external-01-${local.rand.edge_dns_id}.${local.region}.elb.amazonaws.com"
  elb_arn      = "arn:aws:elasticloadbalancing:${local.region}:${local.acct}"
  edge_elb_arn = "arn:aws:elasticloadbalancing:${local.region}:${local.edge_acct}"
  edge_alb_arn = "${local.edge_elb_arn}:loadbalancer/app/cal-o-alb-external-01/${local.rand.edge_alb_id}"
  edge_lsn_arn = "${local.edge_elb_arn}:listener/app/cal-o-alb-external-01/${local.rand.edge_alb_id}/${local.rand.edge_listener}"
  edge_ports   = [8081, 8082, 8083, 8181, 8182, 8183]

  # fe listens on 808x, be on 818x.
  internal_lb = {
    for tier, base in { "fe" = 8080, "be" = 8180 } : "${tier}-lb" => {
      arn                    = "${local.elb_arn}:loadbalancer/net/cal-o-nlb-internal-${tier}-01/${local.lb_ids[tier].lb}"
      id                     = "${local.elb_arn}:loadbalancer/net/cal-o-nlb-internal-${tier}-01/${local.lb_ids[tier].lb}"
      name                   = "cal-o-nlb-internal-${tier}-01"
      dns_name               = "cal-o-nlb-internal-${tier}-01-${local.lb_ids[tier].lb}.elb.${local.region}.amazonaws.com"
      listener_arns = {
        for i, app in local.apps : "http_${base + i + 1}" =>
        "${local.elb_arn}:listener/net/cal-o-nlb-internal-${tier}-01/${local.lb_ids[tier].lb}/${local.lb_ids[tier].listeners[app]}"
      }
      private_ip_addresses = tolist(["", ""])
      target_group_arns = {
        for app in local.apps : "${app}-${tier}" =>
        "${local.elb_arn}:targetgroup/cal-o-${local.lb_ids[tier].tg_names[app]}/${local.lb_ids[tier].tg_ids[app]}"
      }
      target_group_names = {
        for app in local.apps : "${app}-${tier}" => "cal-o-${local.lb_ids[tier].tg_names[app]}"
      }
    }
  }

  app_record = { for app in local.apps : app => {
    for tier in keys(local.tiers) : "${app}-${tier}" => {
      fqdn           = "${app}-${tier}-poc.${local.domain}"
      name           = "${app}-${tier}-poc"
      records        = toset([local.edge_dns])
      set_identifier = "${app}-${tier}-o-edge-alb"
      type           = "CNAME"
    }
  } }
}

output "api_gateway" {
  value = {
    api_key_id             = local.rand.api_key_id
    invoke_url             = "https://${local.rand.rest_api_id}.execute-api.${local.region}.amazonaws.com/prod"
    rest_api_arn           = "arn:aws:apigateway:${local.region}::/restapis/${local.rand.rest_api_id}"
    rest_api_execution_arn = "arn:aws:execute-api:${local.region}:${local.acct}:${local.rand.rest_api_id}"
    rest_api_id            = local.rand.rest_api_id
    stage_name             = "prod"
    usage_plan_id          = local.rand.usage_plan_id
  }
}

output "be_lb" {
  value = { "be-lb" = local.internal_lb["be-lb"] }
}

output "fe_lb" {
  value = { "fe-lb" = local.internal_lb["fe-lb"] }
}

output "bedrock_guardrail" {
  value = {
    guardrail_id      = local.rand.guardrail_id
    guardrail_version = local.rand.guardrail_ver
  }
}

output "ecs_clusters" {
  value = {
    for tier, label in local.tiers : label => {
      cluster_id     = "arn:aws:ecs:${local.region}:${local.acct}:cluster/cal-o-${tier}-cluster"
      cluster_name   = "cal-o-${tier}-cluster"
      log_group_name = "/ecs/cal-o-${tier}-cluster-logs"
    }
  }
}

output "ecs_services" {
  value = merge([
    for app in local.apps : {
      for tier in keys(local.tiers) : "${app}-${tier}" => {
        cluster_name = "cal-o-${tier}-cluster"
        service_name = "cal-o-${app}-${tier}-svc"
      }
    }
  ]...)
}

output "ecs_task_definitions" {
  value = merge([
    for app in local.apps : {
      for tier in keys(local.tiers) : "${app}-${tier}" => {
        task_definition_arn = "arn:aws:ecs:${local.region}:${local.acct}:task-definition/cal-o-${app}-${tier}-task:${local.rand.task_revision}"
        task_role_arn       = "arn:aws:iam::${local.acct}:role/cal-o-${app}-${tier}-task-app-role"
        task_role_name      = "cal-o-${app}-${tier}-task-app-role"
      }
    }
  ]...)
}

output "edge_alb" {
  value = {
    arn                      = local.edge_alb_arn
    id                       = local.edge_alb_arn
    canonical_hosted_zone_id = local.rand.hosted_zone_id
    dns_name                 = local.edge_dns
    name                     = "cal-o-alb-external-01"
    listener_arns            = { https = local.edge_lsn_arn }
    listener_rule_arns = {
      for key, id in local.edge_rule_ids : key =>
      "${replace(local.edge_lsn_arn, ":listener/", ":listener-rule/")}/${id}"
    }
    target_group_arns = {
      for port in local.edge_ports : "nlb-${port}" =>
      "${local.edge_elb_arn}:targetgroup/cal-o-nlb-${port}-tg/${local.edge_tg_ids[tostring(port)]}"
    }
    target_group_names = {
      for port in local.edge_ports : "nlb-${port}" => "cal-o-nlb-${port}-tg"
    }
  }
}

output "lambda_arns" {
  value = {
    for fn in [
      "application_analytics_report",
      "cda_sharepoint_document_analyzer",
      "post_salesforce_appointments",
      "post_salesforce_appointments_processor",
    ] : fn => "arn:aws:iam::${local.acct}:role/cal-${fn}-o-nonprod-role"
  }
}

output "opensearch" {
  value = {
    dashboard_endpoint = "vpc-cal-o-nonprod-${local.rand.opensearch_hash}.${local.region}.es.amazonaws.com/_dashboards"
    domain_arn         = "arn:aws:es:${local.region}:${local.acct}:domain/cal-o-nonprod"
    domain_endpoint    = "vpc-cal-o-nonprod-${local.rand.opensearch_hash}.${local.region}.es.amazonaws.com"
    domain_id          = "${local.acct}/cal-o-nonprod"
  }
}

output "route53_records" {
  value = {
    alb = {
      fqdn    = "cda-poc.${local.domain}"
      name    = "cda-poc.${local.domain}"
      records = toset([local.edge_dns])
      type    = "CNAME"
    }
    app_records    = { for app in local.apps : "${app}-fe" => local.app_record[app]["${app}-fe"] }
    be_app_records = { for app in local.apps : "${app}-be" => local.app_record[app]["${app}-be"] }
  }
}

output "sns_topics" {
  value = {
    for key, name in {
      indexer_alert = "cal-o-sharepoint-index-alert-sns"
      report        = "cal-o-analytics-report-notification-sns"
      } : key => {
      topic_arn  = "arn:aws:sns:${local.region}:${local.acct}:${name}"
      topic_id   = "arn:aws:sns:${local.region}:${local.acct}:${name}"
      topic_name = name
    }
  }
}

output "sqs_queue" {
  value = {
    queue_arn = "arn:aws:sqs:${local.region}:${local.acct}:cal-o-sharepoint-document-indexing-sqs"
    queue_url = "https://sqs.${local.region}.amazonaws.com/${local.acct}/cal-o-sharepoint-document-indexing-sqs"
  }
}
