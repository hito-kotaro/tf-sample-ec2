# tf-sample-ansible
1つのサブネットにEC2を指定した数作成するテンプレート

# Features
## aws
* VPC
* EC2

# Requirement
* Terraform v1.0.6

# Installation

## git clone

```zsh
$ git clone https://github.com/hito-kotaro/tf-sample-ec2.git
$ cd tf-sample-ansible
```

## create terraform.tfvars
```zsh
$ touch terraform.tfvars
$ vim terraform.tfvars
```

### terraform.tfvars
```
# terraform.tfvars
key_name = <YOUR SECRET KEY NAME FOR EC2 ACCESS>
ec2_cnt = <NUM OF INSTANCE>
```

## ecexute terraform 
```zsh
$ terraform init 
$ terraform apply
```
