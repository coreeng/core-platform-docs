+++
title = "Secret Management"
weight = 9
chapter = false
pre = ""
+++

The Core Platform allows a tenant to store secretes in GCP secret manager and access them securely from your application.
It builds on top of the [Secrets Store CSI Driver](https://github.com/kubernetes-sigs/secrets-store-csi-driver) allowing 
the Core Platform to support multiple secret store providers in the future.

## Accessing secret value from a service

The CSI Driver will mount your secrets as files in the service pod.
This allows to decouple the actual secret storage and the service using the secrets.

Here we assume that you already have a secret created in your secret storage.
If not, [here is the instruction](#creating-a-secret)

First of all, you need to have configured `cloudAccess` for your tenant. Provisioned service account will be used to
access the secret. Read more about `cloudAccess` [here](accessing-cloud-infra)

Next, you need to create `SecretStorageClass` object in your namespace that will describe the secrets you want to access.
Here is the example for the GCP Secret Manager:
```yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: app-secrets
  namespace: {{ .namespace }}
spec:
  provider: gcp
  parameters:
    secrets: |
      - resourceName: "projects/{{ .projectNumber }}/secrets/{{ .tenantName }}_{{ .secretName }}/versions/latest"
        path: "secret.txt"
```

You also need to create a service account that will be used by the CSI Driver and your service to access the secret:
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ .cloudAccess.kubernetesServiceAccount.name }}
  namespace: {{ .namespace }}
  annotations:
    # if you use GCP Secret Manager as your secret store, you need to impersonate cloudAccess service account,
    # so CSI Driver can fetch and mount the secret
    iam.gke.io/gcp-service-account: {{ .tenantName }}-{{ .cloudAccess.name }}@{{ .projectId }}.iam.gserviceaccount.com
```

Finally, your application pod `Pod` that will impersonate the service account created above and have the secret mounted by the CSI Driver:
Typically this will be part of a [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) or Job.
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
  namespace: {{ .namespace }}
spec:
  serviceAccountName: {{ .cloudAccess.kubernetesServiceAccount.name }}
  containers:
  - image: alpine:3
    name: mypod
    command:
      # Accessing the secret
      - cat
      - /var/secrets/secret.txt
    volumeMounts:
      # The path where all the secrets described in SecretProviderClass will be mounted
      - mountPath: "/var/secrets"
        name: mysecret
  volumes:
  - name: mysecret
    csi:
      driver: secrets-store.csi.k8s.io
      readOnly: true
      volumeAttributes:
        # Reference the SecretProviderClass created above
        secretProviderClass: "app-secrets"
```

## Creating a secret

To create a secret, you should be a member of tenants `adminGroup`.
Once you create a secret, you can add versions for this secret either being a member of tenants `adminGroup` or via P2P pipelines.

You can either use [Secret Manager UI Console](https://cloud.google.com/security/products/secret-manager) or `gcloud` CLI.
It should be fairly straightforward to create a secret using UI.

Here is the example of using `gcloud` CLI:
```bash
gcloud secrets create <tenant-name>_<secret-name> --data-file=./secret-value.txt
```
This command will create a secret with name `<tenant-name>_<secret-name>` and the first version with value taken from `./secret-value.txt` file.
You can omit `--data-file` parameter to create a secret with no versions.

To add a new version for the secret, you can use the following command:
```bash
gcloud secrets versions add <tenant-name>_<secret-name> --data-file=./new-secret-value.txt
```

## RBAC Model

Since secrets contain sensitive information,
it's important to understand the RBAC model for secret management. Here are the main rules:
{{% notice info %}}
- A tenant can't access the secrets of another tenant. This is enforced by specifying the `<tenant_name>_` as secret name prefix.
- A tenant `adminGroup` has full access to manage the tenants' secrets
- A tenant `readonlyGroup` can only access the secret values
- P2P service account of a tenant can only add versions to existing secrets
- Service accounts created as `cloudAccess` service accounts can only access the secret values
  {{% /notice %}}

## Accessing a secret

To access a secret, you should be either a member of tenants `adminGroup` or `readonlyGroup` or impersonate service account 
created as `cloudAccess` service account.

## GCP Secret Manager
You can either use [Secret Manager UI Console](https://cloud.google.com/security/products/secret-manager) or `gcloud` CLI.
It should be fairly straightforward to access a secret using UI.

Here is the example of using `gcloud` CLI:
```bash
gcloud secrets versions access <version> --secret <tenant-name>_<secret-name>
```

This command will print the value of the specified secret version. 
You can also specify version alias or `latest` as `<version>`.

## Secret rotation

Secret rotation means changing the value of secret once in a while.
It helps to:
- Limit the impact in the case of a leaked secret.
- Ensure that individuals who no longer require access to a secret aren't able to use old secret values.
- Continuously exercise the rotation flow to reduce the likelihood of an outage in case of an emergency rotation

To rotate a secret you should create a [new version of the secret](#creating-a-secret) and make your service use the new version.

You have to be aware about a few important things while performing secrets rotation:
- Since SecretProviderClass mounts secrets as files, it's not able to automatically update secret values.
  You have to restart your service to get the new secret value.
- Your previous version of the secret should be kept active until all the services use the new version of the secret.
  This is to ensure that the service will not become unavailable because of stale secret value.

There is a nice [guide from Google](https://cloud.google.com/secret-manager/docs/rotation-recommendations) about approaches and gotchas on this topic.

# Sharing secrets between tenants
> **Note:** You're not encouraged to, but it's possible to share secrets between tenants.

To make it possible for tenant B to access secret created by tenant A, you should:
- Configure `cloudAccess` of tenant A in a way, that it will be able to impersonate tenant B's service account:
```yaml
name: {{ .tenantA }}
...
cloudAccess:
  - name: ca
    provider: gcp
    environment: {{ .envName }}
    kubernetesServiceAccounts:
      - {{ .tenantB.namespace }}/sa
```
- Create K8S ServiceAccount `sa` in namespace `{{ .tenantB.namespace }}` and make it impersonate tenant A's service
  account:
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: sa
  namespace: {{ .tenantB.namespace }}
  annotations:
    # if you use GCP Secret Manager as your secret store, you need to impersonate cloudAccess service account,
    # so CSI Driver can fetch and mount the secret
    iam.gke.io/gcp-service-account: {{ .tenantA }}-ca@{{ .projectId }}.iam.gserviceaccount.com
```
- Now tenant A's services can access secrets of tenant B's if they use the service account above.

## Pricing

{{% notice note %}}
The following cost forecast assumes running 100 services. For further information please visit: https://cloud.google.com/secret-manager/pricing
{{% /notice %}}

### Access

Each service accessing secret 1000 times in a month = $0.27

Each service accessing secret 10k times in a month = $2.97

### Rotation 

Each service being rotated once in a month = $4.85 

Each service being rotated 5 times in a month = $24.85

## Active secret versions

Each service having 1 active secret = $5.64 

Each service having 5 active secrets = $29.64
