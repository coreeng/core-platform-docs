+++
title = "Setting resource requests"
weight = 4
chapter = false
pre = ""
+++

To set resources on your workloads you need to modify the manifest responsible for deploying your pods e.g. Deployments, Statefulsets or Pods. See [memory vs cpu](../../resources) on recommendations.

## Set Memory Requests & Limits

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

## Set CPU requests and limits

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