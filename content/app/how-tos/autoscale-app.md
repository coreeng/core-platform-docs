+++
title = "Autoscale application"
weight = 4
chapter = false
pre = ""
+++

## Horizontally scale application based on CPU

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: reference-app
  labels:
    app.kubernetes.io/name: reference-app
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: reference-app
  minReplicas: 1
  maxReplicas: 30
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```

## Horizontally scale application based on Memory

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: reference-app
  labels:
    app.kubernetes.io/name: reference-app
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: reference-app
  minReplicas: 1
  maxReplicas: 30
  metrics:
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: 70
```

