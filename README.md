# Terraform Learning

## Course

[Learn Terraform](https://www.linkedin.com/learning/learning-terraform-2/welcome?u=2138932)

## Learning Notes

### What is Terraform

[Terraform](https://github.com/hashicorp/terraform) is a CLI tool for IaC

### Setup

<details>
  <summary>Details</summary>
  
  1. Download and install from https://www.terraform.io/
  2. Setup system PATH
  3. Create AWS profile and setup locally
  4. Setup provider "aws" in first_code.tf
</details>

### Cleanup Provisioned AWS Resources

    terraform plan -destroy -out=destroy.plan
    terraform apply destroy.plan
    
### Commands

<details>
  <summary>Details</summary>
  
<details>
  <summary>terraform init</summary>
  
  1. After init, a ".terraform" folder will be created in current path
  2. During init, Terraform searches the configuration for both direct and indirect references to providers and attempts
   to load the required plugins.
</details>

<details>
  <summary>terraform apply</summary>
  
  - terraform apply
  1. An execution plan will be generated for review.
  2. Reply 'yes' to execute the plan
  3. Execution sample: "Apply complete! Resources: 1 added, 0 changed, 0 destroyed."
  
  - terraform apply xxx.plan
  1. xxx.plan needs to be generated by "terraform plan" everytime
  
  - terraform apply -auto-approve - no prompt when applying
</details>

<details>
  <summary>terraform plan</summary>
  
  1. Check infrastructure state, compare, show results and resource actions if needed
  2. With -destroy option, it will list down what will be destroyed
  3. With -out option, the plan result will be stored in a binary file afterward,
  e.g. terraform plan -destroy -out=destroy.plan
</details>

<details>
  <summary>terraform show</summary>
  
  - terraform show result.plan - display plan content 
  - terraform show - display all states
  - terraform show -json - display all states info in json format
</details>

<details>
  <summary>terraform state</summary>
  
  1. for local storage (in-memory), it's a local terraform.tfstate file (in json format)
  2. remote storage - for team work and version control maybe
  
  - terraform state list - list all terraform resources
  - terraform state show RESOURCE_NAME - show one resource state
</details>

<details>
  <summary>terraform graph - view infrastructure in a graph</summary>
  
  1. generate a visual representation in DOT format which can be used by GraphViz to generate charts.
  2. copy paste output into an online editor to check chart, e.g. [GraphvizOnline](https://dreampuf.github.io/GraphvizOnline)
</details>

</details>

### Resources

- Building blocks of Terraform code
- Define the "what" of infrastructure
- Different settings for every provider

#### Samples

<details>
  <summary>provider</summary>
  
  ```
    provider "aws" {
      profile = "default"
      region = "ap-southeast-2"
    }
  ```
</details>

<details>
  <summary>resource</summary>
  
  ```
    resource "aws_s3_bucket" "tf_course" {
      bucket = "tf-course-20200830"
      acl    = "private"
    }
  ```
</details>

### Basic Resource Types (AWS Samples)

- [document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

<details>
  <summary>AWS Samples</summary>
  
  <details>
    <summary>aws_s3_bucket</summary>
    
    resource "aws_s3_bucket" "terraform_resource_name" {
      bucket = "s3-bucket-unique-name"
      acl    = "private"
      tags = {
        "Terraform" : "true"
      }
      policy = "${file("policy.json")}"
      
      website {
            index_document = "index.html"
            error_document = "error.html"
      }
    }
  </details>
  
  <details>
    <summary>aws_default_vpc</summary>
      
      resource "aws_default_vpc" "default" {
        tags = {
          Name = "Default VPC"
        }
      }
  </details>
  
  <details>
    <summary>aws_security_group</summary>
    
    ...
    
  </details>
  
  <details>
    <summary>aws_instance</summary>
    
    ...
    
  </details>
</details>

### Style

<details>
  <summary>Details</summary>
  
  - Indent two spaces
  - Single meta-arguments first
  - Block meta-arguments last
  - Blank lines for clarity
  - Group single arguments
  - Think about readability
  
</details>

 ### Using Default VPC
 
```
  resource "aws_default_vpc" "default" {}
```

### Variables And Data Sources

- [document](https://www.terraform.io/docs/configuration/variables.html)

<details>
  <summary>Variables Sample</summary>
  
    variable "image_id" {
      type = string
    }
    
    variable "availability_zone_names" {
      type    = list(string)
      default = ["us-west-1a"]
    }
</details>

- [document](https://www.terraform.io/docs/configuration/data-sources.html)

<details>
  <summary>Data Sources Sample</summary>
  
    data "aws_ami" "example" {
      most_recent = true
    
      owners = ["self"]
      tags = {
        Name   = "app-server"
        Tested = "true"
      }
    }
    
    // Dynamic Data
    data "aws_ami" "web" {
      filter {
        name   = "state"
        values = ["available"]
      }
    
      filter {
        name   = "tag:Component"
        values = ["web"]
      }
    
      most_recent = true
    }
</details>
 
 ### Modules
 
 <details>
   <summary>Details</summary>
   
   - [document](https://www.terraform.io/docs/configuration/modules.html)
   - a standard module contains main.tf, variables.tf, outputs.tf and README.md
   - remote modules
   - versioning
   - be carefully with using providers in modules
   - see registry.terraform.io for more modules in community
   - after import module, need to run "terraform init" to download module (if it's from remote)
 </details>

 ## References
 
- [Terraform Best Practices](https://www.terraform-best-practices.com/)