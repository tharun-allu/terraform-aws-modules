# AWS Auto Scaling Group (ASG) Terraform module with multi instance policy to create an ASG with Spot instances or (Mixed)

Terraform module which creates Auto Scaling resources on AWS using mixed instance types.


## Usage

```hcl
module "example" {
  source                  = "../../auto-scaling-group/"
  name                    = "example"
  image_id                = "ami-04b762b4289fba92b"
  instance_type           = "t2.micro"
  min_size                = 1
  max_size                = 2
  max_batch_size          = 1
  min_instance_in_service = 1
  security_group_ids      = ["sg-abcdefgh"]
  key_name                = "test-key"
  subnet_ids              = "subnet-abcdefg,subnet-13450943"
  instance_types          = ["c4.large", "c3.large", "c5.large", "c5n.large", "t2.large", "r3.large", "r4.large"]
  environment             = "test"
  aws_region              = "us-west-2"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | Creates a unique name for autoscaling group | string | `` | yes |
| image\_id | The EC2 image ID to launch | string | `` | no |
| instance\_type | instance type for launch template | string | `` | yes |
| max\_size | The maximum size of the auto scale group | string | - | yes |
| min\_size | The minimum size of the auto scale group | string | - | yes |
| desired\_capacity | The desired size of the auto scale group | integer | - | yes |
| min\_instance\_in\_service | The minimum instances to keep up during updates | integer | - | yes |
| max\_batch\_size | The maximum number of instances to replace during upgrades  | integer | - | yes |
| key\_name | The key name that should be used for the instance | string | `` | no |
| security\_group_ids | A list of security group IDs to assign to the launch configuration | string | `` | yes |
| environment | the STACK tag to the instances | string | `` | yes |
| aws\_region | the region to deploy instances in | string | `` | yes |
| on\_demand\_percentage\_above\_base\_capacity | percentage of ondemand instances in the cluster | integer | `0` | no |
| instance\_types | instance types for acceptable spot instance types for the Auto Scaling Group| string | `` | yes |
