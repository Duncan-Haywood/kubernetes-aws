# Kubernetes AWS Nginx Deployment

This repository contains a Kubernetes manifest to deploy Nginx on an AWS EKS cluster.

## Contents

- `deployment.tf`: Kubernetes manifest for deploying Nginx
- `eks-cluster.tf`: Terraform configuration for provisioning EKS cluster prerequisites 
- `README.md`: This file

## Prerequisites

- Terraform installed
- AWS account with proper permissions to create:
  - EKS cluster
  - Associated VPC, subnets, Internet Gateway etc
- kubectl installed and configured for EKS cluster

## Usage

1. Run `terraform apply` on `eks-cluster.tf` to provision EKS cluster and dependencies 
2. Configure Kubernetes provider in `deployment.tf` to point to new EKS cluster
3. Run `terraform apply` to deploy Nginx deployment
4. Verify deployment:

```
kubectl get deployments
```

This will deploy a basic Nginx deployment on the EKS cluster with 1 replica exposed on port 80.

The Terraform configurations are minimal examples - further customization can be done to parameters like subnet CIDRs, auto scaling configuration etc.