provider "kubernetes" {
  config_context_cluster   = "minikube"
}
resource "kubernetes_service" "loadbalancer" {
  metadata {
    name = "loadbalancer"
  }
  spec {
    selector = {
      app = "wp"
    }
    port {
      port        = 80
      target_port = 80
      node_port = 32123
    }
  type = "NodePort"
  }
}
resource "kubernetes_deployment" "wp-deploy" {
  metadata {
    name = "wp-deploy-aman"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "wp"
      }
    }
    template {
      metadata {
        labels = {
          app = "wp"
        }
      }
      spec {
        container {
          image = "wordpress:4.8-apache"
          name  = "wp-con"
        }
      }
    }
  }
}