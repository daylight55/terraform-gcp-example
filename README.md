# Terraform GCP Examples

Firstly, we will build CloudSQL and Cloud SQL Auth Proxy, DB Client instance.

## 1. CloudSQL on PrivateSubnet connected from GCE with Cloud SQL Auth Proxy

```mermaid
graph LR

%%外部要素のUser
subgraph other
  OU[User]
end

%%グループとサービス
subgraph GC[GCP]
    OU1[Cloud Identity-Aware Proxy]

  subgraph GV1[public-vpc]
    subgraph GS1[public-subnet-1]
      CP1("GCE<br>PostgreSQL Client")
      CP2("GCE<br>Cloud SQL Auth Proxy")
    end
  end
  subgraph GV2[private-vpc]
    %% ※サブネットは指定できない
    subgraph GS2[Allocated range]
      OU2[VPC Peering]
    end
  end

  subgraph GV3[GCP Service Producer VPC]
    DB1[("CloudSQL<br>PostgreSQL")]
    subgraph GS3[s]
      OU3[GCP servicenetworking]
    end
  end

end

%%サービス同士の関係
%% SSH
OU -->OU1
OU1 --"SSH over Cloud IAP"-->  CP1
%% Cloud SQL Auth Proxy authentication
CP1 --> CP2
CP2 --"Service connection and IAM Authentication"--> OU2
%% DB connection
OU2 --> CP2
CP2 --"DB connection"---> DB1

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
※ GCPはVPC全体でルートを定義するためパブリックサブネット/プライベートサブネットの区別はない。外部IPアドレスを付与しなければインターネットに疎通できないため、プライベート定義をしたいものには外部IPアドレスを付与しなければよい。  
参考: [Google CloudのVPCを基礎から始める](https://zenn.dev/google_cloud_jp/articles/google-cloud-vpc-101)


# Getting Started

Setting local variables into `terraform.tfvars`
```
cp terraform.tfvars.example terraform.tfvars
vi terraform.tfvars
```

You'll be provisioning Terraform  & deploy
```
terraform init
terraform plan
terraform apply
```

SSH into DB Client
```
gcloud compute ssh --zone "asia-northeast1-a" "db-client" --tunnel-through-iap --project "xxx"
```

Test DB connection
```
psql "host=<CLOUDSQL_AUTH_PROXY_PRIVATE_IP_ADDRESS> port=5432 sslmode=disable dbname=postgres user=postgres"
```

```

```

## Debug
SSH into CloudAuth Proxy
```
gcloud compute ssh --zone "asia-northeast1-a" "cloudsql-proxy" --tunnel-through-iap --project "xxx"
```


# Requirements
- Allow APIs to GoogleCloud Project
  https://console.cloud.google.com/apis/dashboard?project=<YOUR_PROJECT_ID>
  - Compute Engine API
  - Cloud Resource Manager API
  - Service Networking API
  - Cloud SQL Admin API
  - Identity and Access Management (IAM) API
- IAM permissions to notice
  - servicenetworking.services.addPeering
