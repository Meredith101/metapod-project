variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
  default     = "nice-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "training"
}

variable "root_volume_type" {
  description = "Root volume type for worker groups"
  type        = string
  default     = "gp2"
}

variable "namespace" {
  description = "Namespace for Kubernetes Dashboard and admin user"
  type        = string
  default     = "kubernetes-dashboard"
}

variable "admin_user_name" {
  description = "Admin ServiceAccount name"
  type        = string
  default     = "admin-user"
}

variable "nginx_deployment_name" {
  description = "NGINX deployment name"
  type        = string
  default     = "nginx-deployment"
}

variable "nginx_service_name" {
  description = "NGINX service name"
  type        = string
  default     = "nginx-service"
}

variable "nginx_image" {
  description = "Docker image for NGINX"
  type        = string
  default     = "nginx:latest"
}

variable "nginx_replicas" {
  description = "NGINX replicas"
  type        = number
  default     = 3
}

variable "nginx_container_port" {
  description = "Container port for NGINX"
  type        = number
  default     = 80
}

variable "nginx_node_port" {
  description = "Node port for NGINX service"
  type        = number
  default     = 31380
}
