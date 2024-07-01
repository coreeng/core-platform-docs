+++
title = "Troubleshooting"
weight = 11
chapter = false
pre = ""
+++

## CreateContainerError: failed to reserve container name 
The container runtime is unable to get the container into a running state so it's stuck in pending. 

A potential cause could be resource starvation on nodes. Check the cpu/memory usage of the node the pod is running on:
```
kubectl top node $(kubectl get pod <pod-name> -o jsonpath='{.spec.nodeName}')

NAME                                             CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
gke-sandbox-gcp-sandbox-gcp-pool-18d01f3c-xhd8   174m         9%     2047Mi          33%
```

If the node cpu/memory usage is high, it's possible the container runtime is struggling to find enough resources to be able to run the container.

### Resolution
Ensure that your pod has [cpu/memory requests set](./resources.md). This will allow the kube scheduler to to place your pods on better balanced nodes.

## P2P GCP Auth Fail

I've got a new app and when the P2P tries to authenticate with Google Cloud it fails with an error like this:

```
Error: google-github-actions/auth failed with: retry function failed after 4 attempts: failed to generate Google Cloud federated token for projects/184551133919/locations/global/workloadIdentityPools/p2p-knowledge-platform/providers/p2p-knowledge-platform: (400) {"error":"invalid_target","error_description":"The target service indicated by the \"audience\" parameters is invalid. This might either be because the pool or provider is disabled or deleted or because it doesn't exist."}
```

This is likely as the tenant definition has either not been deployed or doesn't contain the GitHub repo. Without this the GitGub Action does not have permission to authenticate with GCP.

Helpful commands to validate (may need a platform admin to run):

```
kubectl get -n argocd apps <tenant-name>
NAME                 SYNC STATUS   HEALTH STATUS
<tenant-name>        Synced        Healthy
```

Does the tenant exist? Is it healthy? Is it synchedd?

If not:

```
kubectl -n argocd describe app <tenant-name>
```

Why is it not synched/healthy will be in the output.


Does the tenant have the right repo?

```

kubectl get -n argocd apps <tenant-name> -o yaml
```

Should contain output which includes:

```
 - name: tenant.repos
   value: '["https://github.com/coreeng/reference-knowledge-platform-deployment"]'
```

If you've added the repo to the tenant but it isn't shown here then likely the new tenant definition hasn't been deployed to the environment.


## P2P Kubeconfig can not setup tunnel

```
ERROR: (gcloud.compute.start-iap-tunnel) Could not fetch resource:
 - Required 'compute.instances.get' permission for 'projects/chbatey-second-sandbox-vf1o/zones/europe-west2-a/instances/sandbox-gcp-bastion'
```

Follow the same steps as defined in `P2P GCP Auth Fail` to ensure the tenancy is setup correctly.

Then check that the IAMPolicyMember resources are properly syncing with GCP e.g. for a tenant called `knowledge-platform`

```
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



## P2P Helm Numeric Value Error:
### Error:
P2P fails on the helm upgrade step, while trying to apply the helm charts 

- ie running. `helm upgrade --host=localhost --set port=123`), results in error: 


```
ERROR: json: cannot unmarshal number into Go struct field EnvVar.spec.template.spec.containers.env.value of type string
```

This is caused by your helm chart which contains values that are to be overridden, as for example if in our helm chart we had the below with:

```
  host: {{ .Values.Host }}
  port: {{ .Values.Port }}
```

where these are meant to be passed over to kubernetes manifests, we need to guarantee that both of them are treated as string and not as numeric. 

So if in the example above where, you where trying to override with `--set port=123`, this causes parsing issues on the helm and kubernetes side. 

### Solution
To fix this, we can safely "quote" the variables in question as per below:
```
  host: {{ .Values.Host }}
  port: {{ .Values.Port | quote }}
```
