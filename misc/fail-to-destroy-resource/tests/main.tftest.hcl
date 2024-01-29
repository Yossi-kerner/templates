variables {
  name = "OpenTofu"
}

run "basic" {
  assert {
    condition     = output.greeting == "Hello OpenTofu!"
    error_message = "Incorrect greeting: ${output.greeting}"
  }
}

run "override" {
  variables {
    name = "OpenTofu user"
  }
  assert {
    condition     = output.greeting == "Hello OpenTofu user!"
    error_message = "Incorrect greeting: ${output.greeting}"
  }
}