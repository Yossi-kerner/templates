run my_test1 {
  assert {
    condition     = null_resource.test.id == output.this.chaim
    error_message = "null_resource.test.id should be equal to output.this.chaim"
  }
}

run my_test2 {
  assert {
    condition     = null_resource.test.id == output.this.chaim
    error_message = "null_resource.test.id should be equal to output.this.chaim"
  }
}