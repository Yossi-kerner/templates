# Drift Detection Demo (Azure)

Azure counterpart of `aws/drift-demo` — a minimal, self-contained Terraform template for
demoing env0's **Drift Detection** and **Analyze Drift Cause** features. Use it as a fallback
if the AWS demo runs into trouble.

It provisions a resource group and a Storage Account with **public blob access disabled** plus
a variable-driven `Owner` tag — enough to demonstrate three different drift causes from one
template.

## Resources

| Resource | Purpose in the demo |
| --- | --- |
| `azurerm_storage_account.drift_demo` | The managed resource. Toggling "Allow Blob public access" on in the portal is the manual "Unmanaged Change". `allow_nested_items_to_be_public = false` keeps it locked in code. |
| `azurerm_resource_group.drift_demo` | Holds the demo resources. |
| `random_string.suffix` | Keeps the storage account name globally unique (lowercase, 3-24 chars). |

## env0 template setup

- **Repository:** `Yossi-kerner/templates`
- **Terraform Root Folder:** `azure/drift-demo`
- **Terraform version:** 1.x
- **Credentials:** an env0 **Azure** credential. The provider reads `ARM_SUBSCRIPTION_ID` /
  `ARM_*` from it — no `subscription_id` is hard-coded. The service principal needs
  Contributor on the subscription (or target resource group).
- Enable **Drift Detection** in the environment's Settings tab (cron-scheduled).

## Cloud Compass prerequisite (read this — it differs from AWS)

AWS Compass reads historical CloudTrail from S3 via Athena, so timing is forgiving. **Azure
Compass instead queries the `AzureActivity` table in a Log Analytics Workspace (LAW)** and
scans forward (default 90-day lookback). That means:

1. **A Log Analytics Workspace must exist, and Azure Activity Logs must be exported to it**
   via a subscription-level **diagnostic setting** — and that export must be active **before**
   you make the manual change. If the export isn't on at the time of the change, the event
   never lands in the workspace and "Analyze Drift Cause" can't attribute it.
2. **Cloud Compass (Azure)** must be connected with the **Tenant ID**, a **Service Principal
   Client ID + secret**, and the **Log Analytics Workspace ID**. The SP needs
   **Log Analytics Reader** on the workspace.
3. The hero change below is an `Microsoft.Storage/storageAccounts/write` operation —
   Administrative + Success — which is exactly what the Compass query keeps.

## Inducing each drift cause

### 1. Unmanaged Change (the hero)
After a successful deploy:
1. Open the storage account in the Azure portal → **Settings → Configuration**.
2. Set **Allow Blob public access** to **Enabled** and save.
3. Run drift detection → the environment goes **Drifted**.
4. On the deployment's **Drifts** tab, click **Analyze Drift Cause** → with Cloud Compass on
   Azure, env0 shows the activity-log event: who enabled it, when, with a link to the resource.

### 2. Variable Change
Change the env0 environment variable `owner` (e.g. `platform-team` → `someone-else`) without
redeploying. Drift detection flags a **Variable Change**.

### 3. Unapplied Commit
Push a small change to this template (e.g. add a tag in `main.tf`) without deploying.
Drift detection flags an **Unapplied Commit**.

## Cleanup

The storage account is empty and safe to destroy. Re-apply the environment to revert the
manual portal change, or destroy the environment when the demo is done.
