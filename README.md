# Create a Linux VM in Azure with Terraform

# Preparations
## Terraform installation
https://developer.hashicorp.com/terraform/install#linux

## Azure CLI
Installation of Azure CLI

    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

## az login
To run the terraform apply you first need to login at Azure

    az login

## Get Azure Regions
    az account list-locations -o table

## List Subscriptions
    az account list

# Code
## client access values
To access Azure with Terraform you need a client_id and client_secret

Create a Service Principal e.g. terraform in https://entra.microsoft.com

    az ad sp create-for-rbac --name "terraform-sp" --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"


    {
    "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",         # → Client ID
    "displayName": "terraform-sp",
    "password": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",       # → Client Secret
    "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"          # → Tenant ID
    }

In the Azure portal the SP can be seen in Microsoft Entra ID -> App registrations

## terraform.tfvars
Put in here all secret values in terraform.tfvars

client_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

client_secret   = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

tenant_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

This file should not be put in git, because it contains secrets.

Check .gitignore

## Test of SP with az login

    az login --service-principal \
            --username <APP_ID> \
            --password <CLIENT_SECRET> \
            --tenant <TENANT_ID>

## locals.tf
put in here all values, but no secrets

# Terraform commands
## Initialze Terraform
    terraform init [-upgrade]

## Terraform Validate
    terraform validate

## Create a Terraform execution plan
    terraform plan -var-file="terraform.tfvars"

## Execute Terraform
    terraform apply -var-file="terraform.tfvars"

## Delete all remote objets
    terraform destroy

## Environment variables for debugging
    $env:TF_LOG="DEBUG"
    $env:TF_LOG_PATH="terraform.log"

# Access VM with ssh
With the following command you should be able to access the vm

    ssh -i ${local_file.ssh_privat_key.filename} ${var.admin_username}@${azurerm_public_ip.appip.ip_address} -o StrictHostKeyChecking=no -o IdentitiesOnly=yes