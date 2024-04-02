+++
title = "Resources: Requests vs Limits"
weight = 10
chapter = false
pre = ""
+++


When deploying an application to the platform we need to make sure that it has enough resources to operate correctly.

Kubernetes allows to set up `requests` and `limits` for the resources:
- `requests` define the minimum amount of resources that are guaranteed to be available on the host and are reserved for the container. 
The container will not start if this amount is not available.
- `limits` specify the maximum amount of resources to be consumed by the container.

By the word *resources* we usually mean CPU and memory.

### Memory

We define both requests and limits for memory as we need to have its consumption under control.
If the application exceeds the memory limit then it is being terminated due to Out Of Memory condition (OOMKilled).
This means that either the limit is too low or there is a memory leak that needs to be investigated. 

```yaml
  resources:
    requests:
      memory: 50Mi
    limits:
      memory: 100Mi
```

### CPU Requests

A common approach is to set CPU requests without limits. This results in decent scheduling, high utilization of resources and fairness when all containers need CPU cycles.

The container have a minimum amount of CPU even when all the containers on the host are under load. If the other containers on the host are idle or there are no other containers then your container can use all the available CPU.

```yaml
  resources:
    requests:
      cpu: 100m
      memory: 50Mi
    limits:
      memory: 100Mi
```

### CPU Limits for Load Testing

When running stubbed NFT or extended test we need to have stable performance so that we can reliably validate TPS and latency thresholds.

A disadvantage of not having CPU limits is that it is harder to capacity plan your application because the number of resources your container gets varies depending on what else is running on the same host. As a result you can have different results between test runs.

In order to have stable results we set the CPU limits to be the same as requests. Then we scale the deployment to the
required number of `replicas` to handle the load.

```yaml
  replicas: 2
  resources:
    requests:
      cpu: 100m
      memory: 50Mi
    limits:
      cpu: 100m
      memory: 100Mi
```
