# Drift Detection Demo

A minimal, self-contained Terraform template for demoing env0's **Drift Detection** and
**Analyze Drift Cause** features.

It provisions a single private S3 bucket with **Block Public Access** turned on and a
variable-driven `Owner` tag — enough to demonstrate three different drift causes from one
template.

## Resources

| Resource | Purpose in the demo |
| --- | --- |
| `aws_s3_bucket.drift_demo` | The managed resource. Globally-unique name via `random_id`. |
| `aws_s3_bucket_public_access_block.drift_demo` | Hero of the demo. Toggling "Block all public access" off in the console is the manual "Unmanaged Change". |
| `random_id.suffix` | Keeps the bucket name unique. |

## env0 template setup

- **Repository:** `Yossi-kerner/templates`
- **Terraform Root Folder:** `aws/drift-demo`
- **Terraform version:** 1.x
- Enable **Drift Detection** in the environment's Settings tab (cron-scheduled).
- Make sure the deploying credentials allow `s3:*PublicAccessBlock`, `s3:*BucketTagging`,
  and bucket create/delete.

## Inducing each drift cause

### 1. Unmanaged Change (the hero)
After a successful deploy:
1. Open the bucket in the AWS console → **Permissions → Block public access → Edit**.
2. Uncheck **Block all public access** and save.
3. Run drift detection → the environment goes **Drifted**.
4. On the deployment's **Drifts** tab, click **Analyze Drift Cause** → with Cloud Compass
   on AWS, env0 shows the `PutPublicAccessBlock` event: who flipped it, when, with a link
   to the AWS event.

### 2. Variable Change
Change the env0 environment variable `owner` (e.g. `platform-team` → `someone-else`) without
redeploying. Drift detection flags a **Variable Change**.

### 3. Unapplied Commit
Push a small change to this template (e.g. add a tag in `main.tf`) without deploying.
Drift detection flags an **Unapplied Commit**.

## Cleanup

The bucket is empty and safe to destroy. Re-apply the environment to revert the manual
console change, or destroy the environment when the demo is done.
