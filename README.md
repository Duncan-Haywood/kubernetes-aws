# AWS-EKS deployment with Circle CI

This repository provisions EKS on AWS and deploys Nginx using a CircleCI pipeline.

## Overview

The CircleCI pipeline will:

- Provision EKS cluster using Terraform 
- Deploy Nginx manifests to EKS
- Destroy infrastructure on manual approval

Commits to `main` trigger an automated deploy with approval step.

## Pipeline Steps 

On commits to `main`, the pipeline will:

- Format and validate Terraform
- Provision EKS cluster and dependencies 
- Deploy Nginx manifests to EKS

## Requirements

- CircleCI account linked to GitHub repo
- AWS credentials in CircleCI for Terraform 

## Resources Created

- VPC, subnets, and networking for EKS  
- EKS cluster control plane
- EKS managed node group
- Nginx Kubernetes deployment
- Load balancer service for Nginx

## License

This code is released under the MIT License.

## Author

This project was created by Duncan Haywood