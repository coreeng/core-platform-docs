+++
title = "Setting resource requests"
weight = 4
chapter = false
pre = ""
+++

{{% notice note %}}
Setting resource requests can prevent Out of Memory (OOM) and CPU throttling for your workloads
{{% /notice %}}


To set resources on your workloads you need to modify the manifest responsible for deploying your pods e.g. Deployments or Statefulsets. See [memory vs cpu](../../resources) for more details.

## Memory Requests & Limits

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: reference-app
  labels:
    app.kubernetes.io/name: reference-app
spec:
  template:
    spec:
      containers:
      - name: reference-app
        resources:
            requests:
                memory: "512Mi"
            limits:
                memory: "1Gi"
```

## CPU Requests & Limits

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: reference-app
  labels:
    app.kubernetes.io/name: reference-app
spec:
  template:
    spec:
      containers:
      - name: reference-app
        resources:
            requests:
                cpu: "200m"
            limits:
                cpu: "500m"
```