+++
title = "Autoscale application"
weight = 4
chapter = false
pre = ""
+++

For more details on how autoscaling works see [Autoscaling in depth](../../app-autoscaling)

## Horizontally scale application based on CPU
Increase pod replicas if cpu exceeds 60%
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
          averageUtilization: 60
```

## Horizontally scale application based on Memory
Increase pod replicas if memory usage exceeds 60%
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
          averageUtilization: 60
```

## Vertically scale application
Pod cpu/memory requests will automatically be updated based on utilisation. If you do not wish VPA to update pod requests, set `updateMode: Off` 
```yaml
apiVersion: autoscaling.k8s.io/v1beta2
kind: VerticalPodAutoscaler
metadata:
  name: reference-app
  labels:
    app.kubernetes.io/name: reference-app
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: reference-app
  updatePolicy:
    updateMode: "Auto"
  resourcePolicy:
    containerPolicies:
      - containerName: '*'
        minAllowed:
          cpu: 100m
          memory: 50Mi
        maxAllowed:
          cpu: 1
          memory: 1Gi
        controlledResources: ["cpu", "memory"]
```

