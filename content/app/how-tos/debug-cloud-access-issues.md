+++
title = "Debug Cloud Access issues"
weight = 9
chapter = false
pre = ""
+++

## Create gcloud-debug pod

In order to determine whether the problem lies in the application code or is an issue with GCP permissions, you can
deploy a `gcloud-debug` pod to your tenant namespace. This pod can use the same service account as your application,
allowing you to perform operations directly using the `gcloud` CLI.

### Example helm charts for gcloud-debug pod

#### values.yaml

```yaml values.yaml
image:
  repository: google/cloud-sdk
  tag: latest
  pullPolicy: IfNotPresent
```

#### Chart.yaml

```yaml
apiVersion: v2
name: gcloud-debug-pod
version: 0.1.0
description: A simple debug pod for running gcloud commands using the cloud access service account
```

#### templates/debug-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: gcloud-debug
  labels:
    app: gcloud-debug
spec:
  serviceAccountName: <service_account_name>
  containers:
    - name: gcloud-debug
      image: { { .Values.image.repository } }:{{ .Values.image.tag }}
      imagePullPolicy: { { .Values.image.pullPolicy } }
      command: [ "/bin/sh" ]
      args: [ "-c", "sleep 3600" ]
```

## Deploy gcloud-debug pod

This pod can be deployed to your namespace with:

```shell
helm install gcloud-debug-pod helm-charts/gcloud-debug --namespace ${NAMESPACE}
```

## Use gcloud-debug pod for debugging

Once the pod has been deployed, you can open a shell into it:

```shell
kubectl exec -it gcloud-debug --namespace ${NAMESPACE} -- /bin/sh
```

You can now use the `gcloud` CLI as your service account. To verify that the service account is being used, check the
output of `gcloud auth list`.

## Cleanup

After debugging, remember to delete the gcloud-debug pod to clean up your namespace:

```shell
kubectl delete pod gcloud-debug --namespace ${NAMESPACE}
```
