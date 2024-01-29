resource "time_sleep" "wait" {
  create_duration = "1m"
}

resource null_resource test {
  depends_on = [time_sleep.wait]
}

output "this" {
  value = { chaim = null_resource.test.id }
}