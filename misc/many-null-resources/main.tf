resource "null_resource" "bulk" {
  count = 100000

  triggers = {
    id = count.index
  }
}
