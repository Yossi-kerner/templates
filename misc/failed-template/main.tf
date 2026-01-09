
resource "helm_release" "heml" {
 name = "my-helm-release"
 values = [
  "image:\n  repository: nginx\n  tag: 1.16.0\n  pullPolicy: IfNotPresent"
 ]
 chart = "./myetc.tar.gz"
}