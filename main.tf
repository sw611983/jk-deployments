provider "aws" {
  region = "ap-south-1"
}

module "eks" {
  source       = "./modules/eks"
  cluster_name = "my-cluster"
  subnet_ids   = ["subnet-2a54cd66", "subnet-d5d477ae", "subnet-d288a0ba"]
}

data "aws_eks_cluster_auth" "eks_auth" {
  name = module.eks.eks_cluster_id
}

module "k8s" {
  source                  = "./modules/k8s"
  image_url               = "http://jk-deployments.s3-website.ap-south-1.amazonaws.com/"
  eks_cluster_endpoint    = module.eks.eks_cluster_endpoint
  eks_cluster_ca_cert     = module.eks.eks_cluster_ca_cert
  eks_cluster_auth_token  = data.aws_eks_cluster_auth.eks_auth.token
}
