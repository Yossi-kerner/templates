resource "null_resource" "bulk" {
  count = 10000

  triggers = {
    id = count.index
  }
}
