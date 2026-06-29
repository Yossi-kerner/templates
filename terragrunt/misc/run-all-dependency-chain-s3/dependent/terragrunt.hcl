include {
  path = find_in_parent_folders("root.hcl")
}

dependency "base" {
  config_path  = "../base"
  mock_outputs = { id = "mock-id" }
}

inputs = {
  base_id = dependency.base.outputs.id
}
