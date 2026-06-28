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

`mock_outputs` is allowed only for the read-only / pre-apply commands
(`init`, `validate`, `plan`, `workspace`, `output`) so the initial deploy works before
`base` exists, but `apply`/`destroy` are excluded — so a wrong-order destroy still fails,
making the fix observable. No cloud credentials are required (everything is `null_resource`).
