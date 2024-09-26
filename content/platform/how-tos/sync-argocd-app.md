+++
title = "Sync ArgoCD App"
weight = 5
chapter = false
pre = ""
+++

You can use ArgoCD UI to trigger sync for ArgoCD Application.

ArgoCD UI is located at `https://argocd.{{ internalServices.domain }}`

Since tenant resources are provisioned as parts of ArgoCD Application, it might help you to fix issues related to tenancy.

Here are the steps:

- Login as `admin` user
  - To get the password run: `kubectl -n argocd get secret argocd-initial-admin-secret -o json | jq .data.password -r | base64 -D`
- Pick an ArgoCD Application you want to sync:
{{< figure src="/images/how-to/sync-argocd-app/argocd-app-grid.png" >}}
- You can either sync the whole application or select a specific resource:
{{< figure src="/images/how-to/sync-argocd-app/argocd-sync-button.png" >}}
- Select options for sync and click `Synchronize` button. For example, `Force` and `Replace` will cause ArgoCD to recreate resources.
{{< figure src="/images/how-to/sync-argocd-app/argocd-sync-options.png" >}}
