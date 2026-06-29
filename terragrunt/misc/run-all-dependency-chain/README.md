# run-all-dependency-chain

A minimal Terragrunt `run --all` fixture with a real cross-unit dependency, used to QA
destroy ordering (env0 APO-117).

Layout mirrors env0's canonical run-all fixture (root `terragrunt.hcl` with a shared
`generate`, children `include` it) so env0 round-trips state between deploy and destroy:

- `terragrunt.hcl` (root) — generates `null_resource.this` and an `id` output for every unit.
- `base/` — includes the root.
- `dependent/` — includes the root and declares `dependency "base"`, consuming its `id`.

Because `dependent` depends on `base`, ordering matters:

- **Deploy** runs forward: `base` before `dependent`.
- **Destroy** runs reverse: `dependent` before `base` — which is what the APO-117 fix
  produces (`terragrunt run --all -- destroy`, not `-- apply`).

Notes:
- `mock_outputs` is set because env0-managed remote state can't be read during Terragrunt's
  config-resolution phase; it only affects output *values*, not the ordering edge.
- `base_id` is passed via `inputs` but intentionally not declared as a TF variable, so
  OpenTofu doesn't consistency-check it against env0's saved run-all plan.
- No cloud credentials are required (everything is `null_resource`).
