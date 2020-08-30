# Terraform Learning

## Course

[Learn Terraform](https://www.linkedin.com/learning/learning-terraform-2/welcome?u=2138932)

## Learning Notes

### Setup

<details>
  <summary>Details</summary>
  
  1. Download and install from https://www.terraform.io/
  2. Setup system PATH
  3. Create AWS profile and setup locally
  4. Setup provider "aws" in first_code.tf
</details>

### Terraform Commands

<details>
  <summary>terraform init</summary>
  
  1. After init, a ".terraform" folder will be created in current path
  2. During init, Terraform searches the configuration for both direct and indirect references to providers and attempts
   to load the required plugins.
</details>

<details>
  <summary>terraform apply</summary>
  
  1. An execution plan will be generated for review.
  2. Reply 'yes' to execute the plan
  3. Execution sample: "Apply complete! Resources: 1 added, 0 changed, 0 destroyed."
</details>

