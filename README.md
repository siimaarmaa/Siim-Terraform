# Siim-Terraform

Terraform projekt, mis ehitab AWS-i (`eu-west-1`) Elasticsearch'i serverid koos load balanceriga.

## Mida projekt loob

- **1 eraldiseisev server** `siimaarmaa_machine` (Ubuntu, `t2.medium`, 10 GB ketas)
- **Klastri serverid** `cluster_node` (vaikimisi 2 tk, `t2.medium`, 10 GB ketas), mis jaotatakse kahe subneti vahel. Igale serverile paigaldatakse SSH kaudu (`remote-exec`) Elasticsearch 7.x
- **SSH võtmepaar** `siimaarmaaV2` AWS-is (avalik võti failist `siimaarmaa.pem.pub`)
- **Application Load Balancer** `siimaarmaamachinelb`, mis suunab pordi 9200 liikluse klastri serveritele (target group + listener + attachmentid)
- **TLS võti** `siimaarmaa_key1` ja sellest tehtud AWS-i võtmepaar `siimaarmaa_key1`

## Failide ülevaade

| Fail | Sisu |
|---|---|
| `01_provider.tf` | AWS provider, region `eu-west-1` |
| `01_terraform.tf` | `local` provider |
| `02_query.tf` | Olemasolevate ressursside päring: AMI (`devops-ubuntu-18-04-x64*`), subnet, security group `workshop_security` |
| `03_keypair.tf` | AWS key pair `siimaarmaaV2` |
| `04_instance.tf` | Eraldiseisev server `siimaarmaa_machine` |
| `05_tls.tf` | `tls_private_key` ja sellest tehtud key pair |
| `06_nodes.tf` | Klastri serverid + Elasticsearch'i paigaldus |
| `07_sunet.tf` | Kaks subneti (`10.1.101.0/24` ja `10.1.102.0/24`) |
| `08_node_count.tf` | Muutuja `node_count` (vaikimisi `2`) |
| `09_lb.tf` | Load balancer, target group, listener, `lb_dns` output |
| `99_output.tf` | Outputid `ami_id` ja `ip` |
| `terraform.tf` | Remote state: S3 bucket `xa-online-2021-march`, key `siimaarmaa` |
| `.gitlab-ci.yml` | GitLab pipeline: `terraform init` ja `terraform apply -auto-approve` |

## Eeldused

- Terraform ja AWS-i ligipääs (access key / secret key keskkonnamuutujatena)
- Ligipääs S3 bucketile `xa-online-2021-march` (state)
- AWS-is olemas: AMI `devops-ubuntu-18-04-x64*` (omaniku `self` all), security group `workshop_security` ning subnetid `10.1.101.0/24` ja `10.1.102.0/24`
- SSH võtmepaar projekti juurkaustas:
  - `siimaarmaa.pem` (privaatne võti)
  - `siimaarmaa.pem.pub` (avalik võti)

> **Hoiatus:** privaatset võtit (`*.pem`) ei tohi kunagi Giti panna. `.gitignore` blokeerib `*.pem`, aga juba commit'itud faili see ei eemalda. Kui võti on kunagi repos olnud, loe see lekkinuks, genereeri uus ja eemalda vana Giti ajaloost.

## Kasutamine

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply
```

Hävitamiseks:

```bash
terraform destroy
```

Klastri serverite arvu saab muuta:

```bash
terraform apply -var="node_count=4"
```

## Outputid

| Nimi | Tähendus |
|---|---|
| `ami_id` | Kasutatud AMI ID |
| `ip` | Eraldiseisva serveri avalik IP |
| `lb_dns` | Load balanceri DNS-nimi (port 9200) |

Elasticsearch'i kontroll pärast käivitamist:

```bash
curl http://<lb_dns>:9200
```

## CI/CD

GitLab pipeline (`.gitlab-ci.yml`) käivitab `terraform init` ja `terraform apply -auto-approve` etapis `deploy`. Pipeline kasutab image'it `registry.gitlab.com/xa-online-2021-march/builder:latest`.

## Teada piirangud

- Elasticsearch kuulab vaikimisi ainult `localhost`'i ega ole seadistatud klastrina, seega load balanceri health check ei pruugi läbi minna.
- Serverite loomisel kasutatakse SSH-ühendust, mistõttu privaatne võti peab apply ajal failina olemas olema.
