+++
title = "Troubleshooting"
weight = 20
chapter = false
pre = ""
+++

## CreateContainerError: failed to reserve container name

The container runtime is unable to get the container into a running state so it's stuck in pending.

A potential cause could be resource starvation on nodes. Check the cpu/memory usage of the node the pod is running on:

```shell
kubectl top node $(kubectl get pod <pod-name> -o jsonpath='{.spec.nodeName}')

NAME                                             CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
gke-sandbox-gcp-sandbox-gcp-pool-18d01f3c-xhd8   174m         9%     2047Mi          33%
```

If the node cpu/memory usage is high, it's possible the container runtime is struggling to find enough resources to be able to run the container.

### Resolution

Ensure that your pod has [cpu/memory requests set](./resources). This will allow the kube scheduler to to place your pods on better balanced nodes.

## P2P GCP Auth Fail

I've got a new app, and when the P2P tries to authenticate with Google Cloud, it fails with an error like this:

```shell
Error: google-github-actions/auth failed with: retry function failed after 4 attempts: failed to generate Google Cloud federated token for projects/{{ project-number }}/locations/global/workloadIdentityPools/p2p-knowledge-platform/providers/p2p-knowledge-platform: (400) {"error":"invalid_target","error_description":"The target service indicated by the \"audience\" parameters is invalid. This might either be because the pool or provider is disabled or deleted or because it doesn't exist."}
```

This is likely as the tenant definition has either not been deployed or doesn't contain the GitHub repo. Without this the GitGub Action does not have permission to authenticate with GCP.

To find the problem with your tenant deployment, you can either:

- use ArgoCD UI by accessing `https://argocd.{{ internalServices.domain }}`
- `kubectl` CLI (may need a platform admin to run):

> **Note:** all of this is internal implementation details of the platform and may change in the future.

### Check tenant deployment status

> Does the tenant exist? Is it healthy? Is it synchedd?

With `kubectl`:

```shell
kubectl get -n argocd apps <tenant-name>
NAME                 SYNC STATUS   HEALTH STATUS
<tenant-name>        Synced        Healthy
```

With the ArgoCD UI:
{{< figure src="/images/app/troubleshooting/check-tenant-deployment-status.png"
    title="Check tenant deployment status" >}}

### If tenant is not synched/healthy, what is the reason?

With `kubectl`:

```shell
kubectl -n argocd describe app <tenant-name>
```

Why is it not synched/healthy will be in the output.

With the ArgoCD UI:
{{< figure src="/images/app/troubleshooting/tenant-degraded-components.png" title="Tenant degraded components" >}}

### Does the tenant have the right repo?

With `kubectl`:

```shell
kubectl get -n argocd apps <tenant-name> -o yaml
```

It should contain output which includes:

```yaml
 - name: tenant.repos
   value: '["https://github.com/{{ github-org }}/{{ github-repo }}"]'
```

With the ArgoCD UI (App Details > Parameters):
{{< figure src="/images/app/troubleshooting/tenant-repos.png" title="Tenant repos" >}}

If you've added the repo to the tenant,
but it isn't shown here, then likely the new tenant definition hasn't been deployed to the environment.

## P2P Kubeconfig can not setup tunnel

```text
ERROR: (gcloud.compute.start-iap-tunnel) Could not fetch resource:
 - Required 'compute.instances.get' permission for 'projects/{{ project-id }}/zones/europe-west2-a/instances/sandbox-gcp-bastion'
```

Follow the same steps as defined in `P2P GCP Auth Fail` to ensure the tenancy is setup correctly.

Then check that the IAMPolicyMember resources are properly syncing with GCP e.g. for a tenant called `knowledge-platform`

```shell
kubectl -n knowledge-platform get iampolicymembers.iam.cnrm.cloud.google.com                                                                                                                                                      │
NAME                                              AGE   READY   STATUS     STATUS AGE                                                                                                                                                                                            │
artifact-registry-writer-p2p-knowledge-platform   68m   True    UpToDate   68m                                                                                                                                                                                                   │
bastion-account-user-p2p-knowledge-platform       68m   True    UpToDate   68m                                                                                                                                                                                                   │
cluster-access-p2p-knowledge-platform             89m   True    UpToDate   89m                                                                                                                                                                                                   │
compute-os-login-p2p-knowledge-platform           68m   True    UpToDate   68m                                                                                                                                                                                                   │
compute-project-get-p2p-knowledge-platform        68m   True    UpToDate   68m                                                                                                                                                                                                   │
compute-viewer-p2p-knowledge-platform             68m   True    UpToDate   68m                                                                                                                                                                                                   │
iap-user-p2p-knowledge-platform                   68m   True    UpToDate   68m                                                                                                                                                                                                   │
workflow-identity-p2p-knowledge-platform          89m   True    UpToDate   89m
```

For the above error the `compute-os-login-p2p-knowledge-platform` one is responsible for giving access.  

## P2P Helm Numeric Value Error

### Error

P2P fails on the helm upgrade step, while trying to apply the helm charts

- ie running. `helm upgrade --host=localhost --set port=123`), results in error:

```text
ERROR: json: cannot unmarshal number into Go struct field EnvVar.spec.template.spec.containers.env.value of type string
```

This is caused by your helm chart which contains values that are to be overridden, as for example if in our helm chart we had the below with:

```yaml
  host: {{ .Values.Host }}
  port: {{ .Values.Port }}
```

where these are meant to be passed over to kubernetes manifests, we need to guarantee that both of them are treated as string and not as numeric.

So if in the example above where, you where trying to override with `--set port=123`, this causes parsing issues on the helm and kubernetes side.

### Solution

To fix this, we can safely "quote" the variables in question as per below:

```yaml
  host: {{ .Values.Host }}
  port: {{ .Values.Port | quote }}
```
