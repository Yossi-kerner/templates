# run-all-dependency-chain

A minimal Terragrunt `run --all` fixture with a real cross-unit dependency, used to
QA destroy ordering (env0 APO-117).

- `base/` — creates a `null_resource` and exposes a `base_id` output.
- `dependent/` — declares `dependency "base"` and consumes `base_id` via `inputs`.

Because `dependent` must resolve `base`'s outputs, destroy order matters:

- **Reverse order (correct):** `dependent` is destroyed first while `base` still has
  outputs, then `base` — succeeds.
- **Forward order (the bug):** `base` is destroyed first, its state/outputs are gone,
  then `dependent` fails to resolve `dependency.base.outputs.base_id` with
  `detected no outputs`.

`mock_outputs` is set (and allowed for all commands) because env0 manages remote state, so
Terragrunt can't read a dependency's real outputs during its config-resolution phase. The
mock only affects output *values* — the dependency edge still forces ordering: forward on
deploy (`base` → `dependent`), reverse on destroy (`dependent` → `base`). No cloud
credentials are required (everything is `null_resource`).
