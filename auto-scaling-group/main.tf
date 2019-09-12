terraform {
  required_version = ">= 0.12.8"
}
data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.tpl")}"

  vars = {
    name       = "${var.name}"
    aws_region = "${var.aws_region}"
  }
}


#######################
# Launch Template
#######################
resource "aws_launch_template" "this" {
  name_prefix            = "${var.name}-"
  image_id               = "${var.image_id}"
  instance_type          = "${var.instance_type}"
  ebs_optimized          = true
  key_name               = "${var.key_name}"
  vpc_security_group_ids = "${var.security_group_ids}"


  monitoring {
    enabled = true
  }

  user_data = "${base64encode(data.template_file.user_data.rendered)}"

  lifecycle {
    create_before_destroy = true
  }
}

########################################
# Autoscaling group with cloud formation
########################################
resource "aws_cloudformation_stack" "this" {
  name = "${var.name}"

  template_body = <<EOF
Resources:
  AutoScalingGroup:
    Type: AWS::AutoScaling::AutoScalingGroup
    Properties:
      AutoScalingGroupName: "${var.name}"
      DesiredCapacity: "${var.desired_capacity}"
      MinSize: "${var.min_size}"
      MaxSize: "${var.max_size}"
      HealthCheckType: "EC2"
      VPCZoneIdentifier: ${jsonencode(split(",", var.subnet_ids))}
      MixedInstancesPolicy:
        InstancesDistribution:
          OnDemandPercentageAboveBaseCapacity: "${var.on_demand_percentage_above_base_capacity}"
        LaunchTemplate:
          LaunchTemplateSpecification:
            LaunchTemplateId: "${aws_launch_template.this.id}"
            Version: "${aws_launch_template.this.latest_version}"
          Overrides:
          %{ for instance in var.instance_types }
            - InstanceType: ${instance} 
          %{ endfor }
      Tags:
        - Key: Name
          Value: "${var.name}"
          PropagateAtLaunch: true
        - Key: Stack
          Value: "${var.environment}"
          PropagateAtLaunch: true
    CreationPolicy:
      ResourceSignal:
        Count: "${var.min_size}"
        Timeout: PT10M
    UpdatePolicy:
      AutoScalingRollingUpdate:
        MaxBatchSize: "${var.max_batch_size}"
        MinInstancesInService: "${var.min_instance_in_service}"
        PauseTime: PT10M
        SuspendProcesses:
          - AlarmNotification
        WaitOnResourceSignals: true
EOF

  depends_on = ["aws_launch_template.this"]
}
