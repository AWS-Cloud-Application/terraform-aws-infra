# terraform-aws-infra

## Terraform Infrastructure as Code (IaC) with GitHub Actions CI

This project automates the setup of AWS networking infrastructure using Terraform and integrates it with GitHub Actions for Continuous Integration (CI) to ensure proper formatting and validation of Terraform configurations.

Requirements
Before running the Terraform configuration or the GitHub Actions workflow, ensure you have the following:
Terraform (1.5.0 or higher recommended)
AWS CLI installed and configured with a profile

Running Terraform Locally
To run Terraform locally, follow these steps:

1. Set the AWS Region Environment Variable
Set the AWS region you want to use for deploying resources:

2. Initialize Terraform
Run the following command to initialize Terraform:
terraform init

3. Format and Validate Terraform Files
Check the formatting and validate the Terraform configuration:
terraform fmt -check -recursive
terraform validate

4. Apply the Configuration
Run the following command to apply the configuration:
terraform apply

5. Commands to SSL certificate
$ aws acm import-certificate \
    --certificate fileb://demo_kishorkashid_me.crt \
    --private-key fileb://demo.key \
    --certificate-chain fileb://demo_kishorkashid_me.ca-bundle
