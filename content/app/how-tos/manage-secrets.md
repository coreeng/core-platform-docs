+++
title = "Manage secrets"
weight = 6
chapter = false
pre = ""
+++

For more info visit detailed [documentation](../secret-management).

# Accessing secret from service
First of all, you need to have configured `cloudAccess` for your tenant. Provisioned service account will be used to
access the secret.

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
      - resourceName: "projects/{{ .projectId }}/secrets/{{ .tenantName }}_{{ .secretName }}/versions/latest"
        path: "secret.txt"
```

You also need to create a service account that will be used by the CSI Driver and your service to access the secret:
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: secret-sa
  namespace: {{ .namespace }}
  annotations:
    # if you use GCP Secret Manager as your secret store, you need to impersonate cloudAccess service account,
    # so CSI Driver can fetch and mount the secret
    iam.gke.io/gcp-service-account: {{ .tenantName }}-{{ .cloudAccessName }}@{{ .projectId }}.iam.gserviceaccount.com
```

Finally, you need to create a `Pod` that will impersonate the service account created above and have the secret mounted by the CSI Driver:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
  namespace: {{ .namespace }}
spec:
  serviceAccountName: secret-sa
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

