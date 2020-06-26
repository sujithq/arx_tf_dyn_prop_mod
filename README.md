# Terraform: How to create dynamic properties and use output variables from a custom module 

This repo explains how to create dynamic properties and use output variables from a custom module.

Initialize Terraform
``` bash
terraform init
```

Validate scripts
``` bash
terraform validate
```

Plan with d settings
``` bash
terraform plan -var-file .\variables.d.tfvars
```

Plan with q settings
``` bash
terraform plan -var-file .\variables.q.tfvars