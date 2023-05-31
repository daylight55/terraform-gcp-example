# Terraform GCP Examples

Firstly, we will build CloudSQL on a Private subnet and connected from GCE with Cloud Auth Proxy.

## 1. CloudSQL on PrivateSubnet connected from GCE on vary subnet

```mermaid
flowchart LR

%%外部要素のUser
OU1[User]

%%グループとサービス
subgraph GC[GCP]
  subgraph GV[vpc-1]
    subgraph GS1[private-subnet-1]
      CP1("GCE<br>Cloud Auth Proxy")
    end
    subgraph GS2[private-subnet-2]
      DB1[("CloudSQL<br>PostgreSQL")]
    end
  end
end

%%サービス同士の関係
OU1 --"SSH"--> CP1
CP1 --"Authenticated connection"---> DB1

%%グループのスタイル
classDef SGC fill:none,color:#345,stroke:#345
class GC SGC

classDef SGV fill:none,color:#0a0,stroke:#0a0
class GV SGV

classDef SGPrS fill:#def,color:#07b,stroke:none
class GS2 SGPrS

classDef SGPuS fill:#efe,color:#092,stroke:none
class GS1 SGPuS

%%サービスのスタイル
classDef SOU fill:#aaa,color:#fff,stroke:#fff
class OU1 SOU

classDef SNW fill:#84d,color:#fff,stroke:none
class NW1 SNW

classDef SCP fill:#e83,color:#fff,stroke:none
class CP1 SCP

classDef SDB fill:#46d,color:#fff,stroke:#fff
class DB1 SDB

classDef SST fill:#493,color:#fff,stroke:#fff
class ST1 SST

```

# Getting Started

Setting local variables into `terraform.tfvars`
```
vi terraform.tfvars
```

You'll be provisioning Terraform  & deploy
```
terraform init
terraform plan
terraform apply
```
