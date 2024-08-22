+++
title = "Resources: Requests vs Limits"
weight = 9
chapter = false
pre = ""
+++


When deploying an application to the platform we need to make sure that it has enough resources to operate correctly. 
By the word *resources* we usually mean CPU and memory.

Kubernetes allows us to set up `requests` and `limits` for the resources:

- **requests**: minimum amount of resources that are guaranteed to be available for the container.  
- **limits**: maximum amount of resources to be consumed by the container.

| :warning: WARNING                                                                                                |
|:-----------------------------------------------------------------------------------------------------------------|
| **We recommend every critical workload has CPU and memory requests. Otherwise you aren't guaranteed any resources.** |

The Kubernetes scheduler uses **resource requests** to select a node for a Pod to run on. 
Each node has a maximum capacity for each of the resource types: the amount of CPU and memory it can provide for Pods. 
The scheduler ensures that, for each resource type, the `sum of the resource requests of the scheduled containers is less than the capacity of the node`. 

Defining **resource limits** helps ensure that containers never use all available underlying infrastructure provided by nodes.

## Memory

Defining both requests and limits for memory ensures balanced control over consumption.
If the application exceeds the memory limit then it is being terminated due to Out Of Memory condition (OOMKilled).
This means that either the limit is too low or there is a memory leak that needs to be investigated. 

```yaml
  resources:
    requests:
      memory: 50Mi
    limits:
      memory: 100Mi
``` 

## CPU Requests

A common approach is to set CPU requests without limits. This results in decent scheduling, high utilization of resources and fairness when all containers need CPU cycles.

The container will have a minimum amount of CPU even when all the containers on the host are under load. If the other containers on the host are idle or there are no other containers then your container can use all the available CPU.

```yaml
  resources:
    requests:
      cpu: 100m
      memory: 50Mi
    limits:
      memory: 100Mi
```

## CPU Limits for Load Testing

When running stubbed NFT or extended tests we need to have stable performance so that we can reliably validate Transactions Per Second (TPS) and latency thresholds.

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
