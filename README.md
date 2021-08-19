# devops_casestudy

## Question 4:

Configuration in [Question-4](./Question-4) case study creates a set of VPC resources, public/private subnets, Nat Gateway, security group and a EC2 Instance. you can find the templates in [application](./Question-4/application) folder.

Also these resources are created using resuable modules. you can find them in [modules](./Question-4/modules) folder.

#### Usage

To create these resources you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```
> An active authentication to AWS account is a pre requisite for this case-study.

#### Prerequisites

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.31 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.28 |

## Question 5:

Shell script [thirdmost_cpu_mem_process.sh](./Question-5/thirdmost_cpu_mem_process.sh) is capable to provide Process name, cpu, memory, port number and process id of the third most memory and cpu consuming process.
This script is suitable for linux environment.

#### Usage

```bash
$ sh thirdmost_cpu_mem_process.sh
```

#### Prerequisites

- `sudo` permission for the non-root user

## Question 6:

Configuration in [Question-6](./Question-6) case study creates a nginx deployment on a kubernetes cluster with custom configuration using "helm".

#### Usage

To install the Chart with release name `blue-app`:

```bash
$ helm install blue-app Question-6/blue-app
```

#### Prerequisites

- Kubernetes 1.12+
- Helm 3.0-beta3+
