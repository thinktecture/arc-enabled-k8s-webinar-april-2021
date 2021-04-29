resource "digitalocean_kubernetes_cluster" "k8s" {
  name   = "do-k8s-${count.index+1}"
  count = var.cluster_count
  region = var.location[count.index]
  version = "1.19.3-do.3"
  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-4gb"
    node_count = 2
  }

  tags = ["azure-arc-enabled-kubernetes", "demo"]
}
