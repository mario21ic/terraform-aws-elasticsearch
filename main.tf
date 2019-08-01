resource "aws_elasticsearch_domain" "aws_elasticsearch_cluster" {
  domain_name           = "${var.env}-${var.domain_name}"
  elasticsearch_version = "${var.elasticsearch_version}"


  cluster_config {
    instance_type            = "${var.instance_type}"
    instance_count           = "${var.instance_count}"
    dedicated_master_enabled = "${var.dedicated_master_enabled}"
    dedicated_master_type    = "${var.dedicated_master_type}"
    dedicated_master_count   = "${var.dedicated_master_count}"
    zone_awareness_enabled   = "${var.zone_awareness_enabled}"
  }

  vpc_options {
//    vpc_id = "${var.vpc_id}"
    subnet_ids = ["${var.subnets}"]
    security_group_ids = ["${aws_security_group.sg_es.id}"]
  }

  ebs_options {
    ebs_enabled = "${var.ebs_enabled}"
    volume_type = "${var.volume_type}"
    volume_size = "${var.volume_size}"
    iops        = "${var.iops}"
  }

  snapshot_options {
    automated_snapshot_start_hour = "${var.automated_snapshot_start_hour}"
  }

  advanced_options {
    "rest.action.multi.allow_explicit_index" = "${var.rest_action_multi_allow_explicit_index}"
    "indices.fielddata.cache.size"           = "${var.indices_fielddata_cache_size}"
  }

  access_policies = "${var.access_policies}"

  tags {
    Name        = "${var.tag_name}"
    Environment = "${var.tag_environment}"
    Description = "${var.tag_description}"
  }
}


resource "aws_security_group" "sg_es" {
  name        = "${var.env}-sg-es"
  description = "ElasticSearch security group ${var.env}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = ["${var.security_group_access}"]
  }

  tags {
    Name        = "${var.env}-sg-efs-es"
    Env         = "${var.env}"
    Description = "Elasticsearch ${var.env}"
  }
}
