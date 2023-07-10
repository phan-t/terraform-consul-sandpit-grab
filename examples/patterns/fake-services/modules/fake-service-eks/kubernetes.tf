// create kubernetes resources on eks cluster

resource "kubernetes_namespace" "fake-service" {
  metadata {
    name = "fake-service"
  }
}

resource "kubernetes_service" "fake-service" {
  metadata {
    name = "fake-service"
    namespace = "fake-service"
    labels = {
        app = "fake-service"
    }
  }
  spec {
    selector = {
      app = "fake-service"
    }
    port {
      port        = 9090
      target_port = 9090
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service_account" "fake-service" {
  metadata {
    name = "fake-service"
    namespace = "fake-service"
  }
  automount_service_account_token = true
}

resource "kubernetes_deployment" "fake-service" {
  metadata {
    name = "fake-service"
    namespace = "fake-service"
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        service = "fake-service"
        app = "fake-service"
      }
    }
    template {
      metadata {
        labels = {
          service = "fake-service"
          app = "fake-service"
        }
        annotations = {
          "consul.hashicorp.com/connect-inject" = true           
        }
      }
      spec {
        container {
          name  = "fake-service"
          image = "nicholasjackson/fake-service:v0.25.2"
          port {
            container_port = 9090
          }
          env {
            name = "LISTEN_ADDR"
            value = "9090"
          }
          env {
            name = "NAME"
            value = "service-a"
          }
        }
        service_account_name = "fake-service"
      }
    }
  }
  wait_for_rollout = false
}