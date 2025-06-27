provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
}

resource "kubernetes_namespace" "dashboard" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_service_account" "admin_user" {
  metadata {
    name      = var.admin_user_name
    namespace = kubernetes_namespace.dashboard.metadata[0].name
  }
}

resource "kubernetes_cluster_role_binding" "admin_user" {
  metadata {
    name = var.admin_user_name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.admin_user.metadata[0].name
    namespace = kubernetes_service_account.admin_user.metadata[0].namespace
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = var.nginx_deployment_name
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = var.nginx_replicas

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx-container"
          image = var.nginx_image

          port {
            container_port = var.nginx_container_port
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name = var.nginx_service_name
  }

  spec {
    selector = {
      app = "nginx"
    }

    port {
      protocol    = "TCP"
      port        = var.nginx_container_port
      target_port = var.nginx_container_port
      node_port   = var.nginx_node_port
    }

    type = "LoadBalancer"
  }
}
