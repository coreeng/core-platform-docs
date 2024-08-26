+++
chapter = false
Title = "Application Troubleshooting"
weight = 10
+++

## CreateContainerError: failed to reserve container name 
The container runtime is unable to get the container into a running state so it's stuck in pending. 

A potential cause could be resource starvation on nodes. Check the cpu/memory usage of the node the pod is running on:
```
kubectl top node $(kubectl get pod <pod-name> -o jsonpath='{.spec.nodeName}')

NAME                                             CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
gke-sandbox-gcp-sandbox-gcp-pool-18d01f3c-xhd8   174m         9%     2047Mi          33%
```

If the node cpu/memory usage is high, it's possible the container runtime is struggling to find enough resources to be able to run the container.

### Resolution
Ensure that your pod has [cpu/memory requests set](../../../concepts/resources). This will allow the kube scheduler to to place your pods on better balanced nodes.