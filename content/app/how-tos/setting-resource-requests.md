+++
title = "Setting resource requests"
weight = 4
chapter = false
pre = ""
+++

{{% notice warning %}}
Setting a low memory limit can lead to Out Of Memory kills of your application.
{{% /notice %}}

{{% notice note %}}
Setting resource requests can prevent Out of Memory (OOM) and CPU throttling for your workloads. It's usually best to not set CPU limits. See [memory vs cpu](/reference/resources) for more details.
{{% /notice %}}

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
