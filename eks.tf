# terrafrom setup for an eks cluster on aws
# Configure Kubernetes provider 
provider "kubernetes" {
  host                   = aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.example.certificate_authority.0.data)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.example.name]
    command     = "aws"
  }
}

# Create VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = { 
    Name = "EKS VPC"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "EKS IGW" 
  }
}

# Create public subnets 
resource "aws_subnet" "eks_public_subnets" {
  count = 2
  
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "EKS public subnet ${count.index}"
  }
} 


# Create EKS cluster  
resource "aws_eks_cluster" "eks_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_master_role.arn

  vpc_config {
    subnet_ids = aws_subnet.eks_public_subnets[*].id
  }
}

# EKS node IAM role
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# EKS node group 
resource "aws_eks_node_group" "private_ng" {
  cluster_name    = aws_eks_cluster.eks_cluster.name

  node_group_name = "private-nodes"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  subnet_ids = aws_subnet.private[*].id

  scaling_config {
    desired_size = 3
    max_size     = 6
    min_size     = 1
  }

  update_config {
    max_unavailable = 2
  }

  labels = {
    role = "private-node"
  }

  tags = {
    "k8s.io/cluster-autoscaler/enabled" = "true"
    "k8s.io/cluster-autoscaler/${aws_eks_cluster.eks_cluster.name}" = "owned"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]
}