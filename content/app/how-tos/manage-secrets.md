+++
title = "Manage secrets"
weight = 6
chapter = false
pre = ""
+++

For more info visit detailed [documentation](/reference/secret-management).

# Accessing secret from service

First of all, you need to have configured `cloudAccess` for your tenant. Provisioned service account will be used to
access the secret. Read more about `cloudAccess` [here](/reference/accessing-cloud-infra)

Next, you need to create `SecretStorageClass` object in your namespace that will describe the secrets you want to access.

> **Note:** if you don't have a secret created in your secret storage, [here is the instruction](#create-secrets).

## Create SecretProviderClass for GCP

```yaml
apiVersion: secrets-store.csi.x-k8s.io/v1alpha1
kind: SecretProviderClass
metadata:
  name: app-secrets
  namespace: {{ .namespace }}
spec:
  provider: gcp
  secretObjects:
  - secretName: {{ .secretName }}
    type: Opaque
    data: 
    - objectName: secret.txt
      key: {{ .key }}
  parameters:
    secrets: |
      - resourceName: "projects/{{ .projectNumber }}/secrets/{{ .tenantName }}_{{ .secretName }}/versions/latest"
        fileName: "secret.txt"
```

## Create Service Account used to access secret

This will be used by the CSI driver

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ .cloudAccess.kubernetesServiceAccount.name }}
  namespace: {{ .namespace }}
  annotations:
    # if you use GCP Secret Manager as your secret store, you need to impersonate cloudAccess service account to allow CSI Driver to fetch and mount the secret
    iam.gke.io/gcp-service-account: {{ .tenantName }}-{{ .cloudAccess.name }}@{{ .projectId }}.iam.gserviceaccount.com
```

## Reference secret in application

{{% notice note %}}
In order for a secret to be available through env variables, it first must be mounted by pod accessing it.
{{% /notice %}}

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: foo
  namespace: {{ .namespace }}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: foo
  template:
    metadata:
      labels:
        app: foo
    spec:
      serviceAccountName: {{ .cloudAccess.kubernetesServiceAccount.name }}
      containers:
      - image: alpine:3
        name: foo
        # Accessing secret via environment variable
        env:
        - name: SECRET_USERNAME
          valueFrom:
            secretKeyRef:
              name: {{ .secretName }}
              key: {{ .key }}
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

# Create secrets

## GCP Secret Manager

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

# Accessing secrets

## GCP Secret manager

You can either use [Secret Manager UI Console](https://cloud.google.com/security/products/secret-manager) or `gcloud` CLI.
It should be fairly straightforward to access a secret using UI.

Here is the example of using `gcloud` CLI:

```bash
gcloud secrets versions access <version> --secret <tenant-name>_<secret-name>
```

This command will print the value of the specified secret version.
You can also specify version alias or `latest` as `<version>`.
