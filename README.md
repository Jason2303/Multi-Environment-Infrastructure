\# Terraform Multi-Environment Infrastructure



Terraform project that provisions identical infrastructure across three environments (dev, staging, prod) using reusable modules, with environment-specific sizing and configuration.



\## Architecture Diagram



```mermaid

graph TD

&#x20;   subgraph "Shared Modules"

&#x20;       N\[Networking Module]

&#x20;       C\[Compute Module]

&#x20;       D\[Database Module]

&#x20;       M\[Monitoring Module]

&#x20;   end



&#x20;   subgraph "Dev Environment"

&#x20;       DEV\[environments/dev] --> N

&#x20;       DEV --> C

&#x20;       DEV --> D

&#x20;       DEV --> M

&#x20;   end



&#x20;   subgraph "Staging Environment"

&#x20;       STG\[environments/staging] --> N

&#x20;       STG --> C

&#x20;       STG --> D

&#x20;       STG --> M

&#x20;   end



&#x20;   subgraph "Prod Environment"

&#x20;       PRD\[environments/prod] --> N

&#x20;       PRD --> C

&#x20;       PRD --> D

&#x20;       PRD --> M

&#x20;   end



&#x20;   N -- VPC ID, Subnet IDs --> C

&#x20;   N -- VPC ID, Subnet IDs --> D

&#x20;   C -- Security Group ID --> D

&#x20;   C -- ASG Name --> M

```



```

┌─────────────────────────────────────────────────────────────────┐

│                        AWS Account                              │

│                                                                 │

│  ┌───────────────────── VPC (10.x.0.0/16) ───────────────────┐  │

│  │                                                            │  │

│  │  ┌──────────────────┐       ┌───────────────────────────┐  │  │

│  │  │  Public Subnets  │       │     Private Subnets       │  │  │

│  │  │                  │       │                           │  │  │

│  │  │  ┌────────────┐  │       │  ┌──────────┐ ┌────────┐  │  │  │

│  │  │  │ NAT Gateway│  │       │  │ EC2 ASG  │ │  RDS   │  │  │  │

│  │  │  └─────┬──────┘  │       │  │(Compute) │ │  (DB)  │  │  │  │

│  │  │        │         │       │  └────┬─────┘ └───┬────┘  │  │  │

│  │  │  ┌─────┴──────┐  │       │       │  SG Ref   │       │  │  │

│  │  │  │    IGW     │  │       │       └───────────┘       │  │  │

│  │  │  └────────────┘  │       │                           │  │  │

│  │  └──────────────────┘       └───────────────────────────┘  │  │

│  │                                                            │  │

│  └────────────────────────────────────────────────────────────┘  │

│                                                                 │

│  ┌─────────────── CloudWatch Monitoring ──────────────────────┐  │

│  │  Log Group  ←  EC2 Instances                               │  │

│  │  CPU Alarm  →  SNS Topic  →  Email Notification            │  │

│  └────────────────────────────────────────────────────────────┘  │

│                                                                 │

│  ┌─────────────── Remote State ───────────────────────────────┐  │

│  │  S3 Bucket (versioned, encrypted, public access blocked)   │  │

│  │  Separate state keys: dev/ staging/ prod/                  │  │

│  └────────────────────────────────────────────────────────────┘  │

└─────────────────────────────────────────────────────────────────┘

```



\## Project Structure



```

terraform-multi-env/

├── modules/

│   ├── networking/        

│   │   ├── main.tf

│   │   ├── variables.tf

│   │   └── outputs.tf

│   ├── compute/            

│   │   ├── main.tf

│   │   ├── variables.tf

│   │   └── outputs.tf

│   ├── database/           

│   │   ├── main.tf

│   │   ├── variables.tf

│   │   └── outputs.tf

│   └── monitoring/         

│       ├── main.tf

│       ├── variables.tf

│       └── outputs.tf

├── environments/

│   ├── dev/

│   │   ├── main.tf         

│   │   ├── variables.tf

│   │   ├── outputs.tf

│   │   ├── terraform.tfvars

│   │   └── backend.tf      

│   ├── staging/            

│   └── prod/               

├── backend/                

│   ├── main.tf

│   └── variables.tf

├── .github/

│   └── workflows/

│       └── terraform.yml   

├── infracost.yml

└── README.md

```



\## Module Documentation



\### Networking



Creates the VPC that contains all resources, including public and private subnets, an internet gateway, NAT gateways, and route tables for traffic within the VPC. Subnets use `for\_each` over a map, allowing flexible subnet configuration per environment.



| Input | Type | Description |

|-------|------|-------------|

| `vpc\_cidr` | `string` | CIDR block for the VPC |

| `environment` | `string` | Environment name (dev, staging, prod) |

| `common\_tags` | `map(string)` | Tags applied to all resources |

| `public\_subnets` | `map(object)` | Map of public subnets with CIDR and AZ |

| `private\_subnets` | `map(object)` | Map of private subnets with CIDR and AZ |

| `single\_nat\_gateway` | `bool` | Use one NAT gateway instead of one per AZ |



| Output | Description |

|--------|-------------|

| `vpc\_id` | VPC ID |

| `public\_subnet` | Map of public subnet IDs |

| `private\_subnet` | Map of private subnet IDs |



\### Compute



Creates the security group for EC2 instances within the private subnets, allowing SSH connections from a specified CIDR range. Provisions a launch template and an autoscaling group for the EC2 instances.



| Input | Type | Description |

|-------|------|-------------|

| `vpc\_id` | `string` | VPC ID from networking module |

| `private\_subnet\_id` | `list(string)` | Private subnet IDs from networking module |

| `instance\_type` | `string` | EC2 instance type |

| `ami\_id` | `string` | AMI ID for EC2 instances |

| `key\_pair` | `string` | Key pair name for SSH access |

| `asg\_sizes` | `object` | Min, max, and desired capacity for the ASG |

| `allowed\_ssh\_cidr` | `string` | CIDR range allowed to SSH into instances |

| `environment` | `string` | Environment name |

| `common\_tags` | `map(string)` | Tags applied to all resources |



| Output | Description |

|--------|-------------|

| `security\_group\_id` | Compute security group ID |

| `autoscaling\_group\_name` | ASG name |



\### Database



Contains the security group for the database, allowing inbound connections only from the compute security group. Provisions an RDS instance with configurable engine, instance class, and storage. Since the module accepts engine and version as variables, it supports any relational database the user chooses (PostgreSQL, MySQL).



| Input | Type | Description |

|-------|------|-------------|

| `vpc\_id` | `string` | VPC ID from networking module |

| `private\_subnet\_id` | `list(string)` | Private subnet IDs for DB subnet group |

| `compute\_security\_group\_id` | `string` | Compute SG ID for ingress rules |

| `database\_name` | `string` | Database name |

| `database\_username` | `string` | Master username |

| `database\_password` | `string` | Master password (sensitive) |

| `database\_engine` | `string` | Database engine (postgres, mysql) |

| `database\_engine\_version` | `string` | Engine version |

| `database\_instance\_type` | `string` | RDS instance class |

| `database\_storage` | `number` | Allocated storage in GB |

| `multi\_az` | `bool` | Enable Multi-AZ deployment |

| `environment` | `string` | Environment name |

| `common\_tags` | `map(string)` | Tags applied to all resources |



| Output | Description |

|--------|-------------|

| `hostname` | RDS instance address (hostname) |

| `database\_name` | Database name |

| `database\_port` | Database port (5432 or 3306) |



\### Monitoring



Collects logs from the application tier using CloudWatch, monitors CPU utilization on the ASG, and triggers an alarm when usage exceeds the configured threshold. Notifications are sent to a specified email address via SNS.



| Input | Type | Description |

|-------|------|-------------|

| `environment` | `string` | Environment name |

| `common\_tags` | `map(string)` | Tags applied to all resources |

| `asg\_name` | `string` | ASG name from compute module |

| `cpu\_threshold` | `number` | CPU percentage threshold for alarm |

| `retention\_in\_days` | `number` | CloudWatch log retention period |

| `email` | `string` | Email address for alarm notifications |



| Output | Description |

|--------|-------------|

| `sns\_topic\_arn` | SNS topic ARN |

| `log\_group` | CloudWatch log group name |



\## Usage Instructions



\### Prerequisites



\- Terraform 1.10 or later

\- AWS CLI configured with appropriate credentials

\- An AWS account with permissions for VPC, EC2, RDS, CloudWatch, and SNS



\### Deploying an Environment



1\. Clone the repository:

&#x20;  ```bash

&#x20;  git clone <repository-url>

&#x20;  cd terraform-multi-env

&#x20;  ```



2\. Navigate to the desired environment:

&#x20;  ```bash

&#x20;  cd environments/dev

&#x20;  ```



3\. Set the database password (do not store this in files):

&#x20;  ```bash

&#x20;  export TF\_VAR\_database\_password="your-secure-password-here"

&#x20;  ```

&#x20;  On PowerShell:

&#x20;  ```powershell

&#x20;  $env:TF\_VAR\_database\_password = "your-secure-password-here"

&#x20;  ```



4\. Initialize Terraform:

&#x20;  ```bash

&#x20;  terraform init

&#x20;  ```



5\. Format and validate:

&#x20;  ```bash

&#x20;  terraform fmt -check

&#x20;  terraform validate

&#x20;  ```



6\. Review the execution plan:

&#x20;  ```bash

&#x20;  terraform plan

&#x20;  ```



Repeat for `staging` and `prod` environments.



\### Remote State Backend



The S3 backend configuration is commented out in each environment's `backend.tf`. To enable it:



1\. First, provision the S3 bucket using the config in `backend/`.

2\. Uncomment the backend block in the target environment's `backend.tf`.

3\. Run `terraform init` to migrate state to S3.



Each environment uses a separate state key (`dev/terraform.tfstate`, `staging/terraform.tfstate`, `prod/terraform.tfstate`) within the same bucket. State locking uses `use\_lockfile = true` (DynamoDB is not required).



\## Environment Differences



| Setting | Dev | Staging | Prod |

|---------|-----|---------|------|

| Instance Type | t3.micro | t3.small | t3.medium |

| ASG (min/max/desired) | 1/1/1 | 1/2/1 | 1/5/3 |

| DB Instance | db.t3.micro | db.t3.small | db.t3.medium |

| DB Storage | 20 GB | 30 GB | 50 GB |

| Multi-AZ | No | No | Yes |

| NAT Gateway | Single | Single | Single |

| VPC CIDR | 10.0.0.0/16 | 10.3.0.0/16 | 10.2.0.0/16 |

| CPU Alarm Threshold | 80% | 70% | 60% |

| Log Retention | 14 days | 30 days | 365 days |



\## Security



\- \*\*Database network isolation:\*\* The database security group only allows inbound traffic from the compute security group, referenced by security group ID rather than CIDR. This ensures only application instances can reach the database without over-privileging access.

\- \*\*Database authentication:\*\* Access to the database requires a username and password known only to the administrator. The password is marked as `sensitive` in Terraform and is never stored in `.tfvars` files.

\- \*\*Password handling:\*\* The database password is set via the `TF\_VAR\_database\_password` environment variable rather than being committed to source control. In CI/CD, it is stored as a GitHub Actions encrypted secret.

\- \*\*RDS encryption:\*\* Storage encryption is enabled on all database instances (`storage\_encrypted = true`).

\- \*\*Remote state encryption:\*\* The S3 state bucket uses AES-256 server-side encryption and blocks all public access.

\- \*\*SSH access:\*\* Inbound SSH is restricted to a specific CIDR range per environment, not open to the internet.



\## CI/CD



A GitHub Actions workflow runs on every pull request to `main`. It performs the following for each environment (dev, staging, prod) in parallel:



1\. `terraform fmt -check` — ensures consistent formatting

2\. `terraform init` — initializes providers and modules

3\. `terraform validate` — checks configuration syntax and references

4\. `terraform plan` — previews infrastructure changes



After all environments pass, a separate Infracost job runs a cost breakdown across all three environments.



\## Tagging Strategy



All resources use a consistent tagging pattern:



```hcl

tags = merge(var.common\_tags, {

&#x20; Name = "${var.environment}-resource-name"

})

```



Common tags (`Project`, `ManagedBy`) are defined once in `terraform.tfvars` and merged with resource-specific tags in every module, ensuring traceability and cost allocation across all environments.

