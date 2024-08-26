+++
title = "Overprovision Pods"
weight = 400
chapter = false
pre = "12. "
+++

{{% notice note %}}
Overprovisioning works well if workloads need to be provisioned immediately. See [why you need overprovisioning](../../platform/cluster-autoscaling#overprovisioning).
{{% /notice %}}

## Overprovision Pods
Create 5 pause pods that will request 1 CPU and 200Mi of memory. In total it will reserve 5 CPU and 1Gi of memory
```yaml
cluster:
  overprovisioning:
    replicas: 5
    cpu: "1"
    memory: "200Mi"
```