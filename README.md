# Siim-Terraform

Terraform project that builds Elasticsearch servers with a load balancer in AWS (`eu-west-1`).

## What the project creates

- **1 standalone server** `siimaarmaa_machine` (Ubuntu, `t2.medium`, 10 GB disk)
- **Cluster servers** `cluster_node` (2 by default, `t2.medium`, 10 GB disk), spread across two subnets. Elasticsearch 7.x is installed on each server over SSH (`remote-exec`)
- **SSH key pair** `siimaarmaaV2` in AWS (public key from `siimaarmaa.pem.pub`)
- **Application Load Balancer** `siimaarmaamachinelb`, forwarding port 9200 traffic to the cluster servers (target group + listener + attachments)
- **TLS key** `siimaarmaa_key1` and an AWS key pair `siimaarmaa_key1` created from it

## File overview

| File | Contents |
|---|---|
| `01_provider.tf` | AWS provider, region `eu-west-1` |
| `01_terraform.tf` | `local` provider |
| `02_query.tf` | Lookups of existing resources: AMI (`devops-ubuntu-18-04-x64*`), subnet, security group `workshop_security` |
| `03_keypair.tf` | AWS key pair `siimaarmaaV2` |
| `04_instance.tf` | Standalone server `siimaarmaa_machine` |
| `05_tls.tf` | `tls_private_key` and the key pair created from it |
| `06_nodes.tf` | Cluster servers + Elasticsearch installation |
| `07_sunet.tf` | Two subnets (`10.1.101.0/24` and `10.1.102.0/24`) |
| `08_node_count.tf` | Variable `node_count` (default `2`) |
| `09_lb.tf` | Load balancer, target group, listener, `lb_dns` output |
| `99_output.tf` | Outputs `ami_id` and `ip` |
| `terraform.tf` | Remote state: S3 bucket `xa-online-2021-march`, key `siimaarmaa` |
| `.gitlab-ci.yml` | GitLab pipeline: `terraform init` and `terraform apply -auto-approve` |

## Prerequisites

- Terraform and AWS access (access key / secret key as environment variables)
- Access to the S3 bucket `xa-online-2021-march` (state)
- Existing in AWS: AMI `devops-ubuntu-18-04-x64*` (owner `self`), security group `workshop_security`, and subnets `10.1.101.0/24` and `10.1.102.0/24`
- SSH key pair in the project root directory:
  - `siimaarmaa.pem` (private key)
  - `siimaarmaa.pem.pub` (public key)

> **Warning:** never commit the private key (`*.pem`) to Git. `.gitignore` blocks `*.pem`, but it does not remove a file that was already committed. If the key has ever been in the repository, treat it as leaked, generate a new one and remove the old one from the Git history.

## Usage

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply
```

To destroy everything:

```bash
terraform destroy
```

The number of cluster servers can be changed:

```bash
terraform apply -var="node_count=4"
```

## Outputs

| Name | Meaning |
|---|---|
| `ami_id` | ID of the AMI used |
| `ip` | Public IP of the standalone server |
| `lb_dns` | DNS name of the load balancer (port 9200) |

Check Elasticsearch after startup:

```bash
curl http://<lb_dns>:9200
```

## CI/CD

The GitLab pipeline (`.gitlab-ci.yml`) runs `terraform init` and `terraform apply -auto-approve` in the `deploy` stage. The pipeline uses the image `registry.gitlab.com/xa-online-2021-march/builder:latest`.

## Known limitations

- By default Elasticsearch listens only on `localhost` and is not configured as a cluster, so the load balancer health checks may fail.
- Provisioning uses an SSH connection, so the private key file must exist at apply time.
