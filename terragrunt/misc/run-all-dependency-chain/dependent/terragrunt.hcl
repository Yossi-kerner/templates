include {
  path = find_in_parent_folders()
}

# Depends on `base` and consumes its output, so Terragrunt must read base's state on every
# run. The dependency edge forces ordering: forward on deploy (base -> dependent), reverse
# on destroy (dependent -> base) - which is the APO-117 fix.
dependency "base" {
  config_path = "../base"

  # env0 manages remote state, so the real outputs aren't readable during Terragrunt's
  # config-resolution phase; the mock lets every command resolve. It only affects the
  # output *value*, not the ordering edge.
  mock_outputs = { id = "mock-id" }
}

# Consumed as an input (not declared as a TF variable below), so OpenTofu ignores the value
# instead of consistency-checking it against env0's saved run-all plan.
inputs = {
  base_id = dependency.base.outputs.id
}
