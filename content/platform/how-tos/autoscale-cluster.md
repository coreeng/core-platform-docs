+++
title = "Autoscale cluster"
weight = 4
chapter = false
pre = ""
+++

Autoscaling your cluster can be done centrally using the `config.yaml` file. See [cluster autoscaling](../../cluster-autoscaling) for why you should autoscale.

## Autoscale nodes
Enable autoscaling in GCP cluster by setting maximum amount of cpu cores and memory cluster can have. Nodes count towards this total.

```yaml
cluster:
  gcp:
    autoscaling:
      cpuCores: 60
      memoryGb: 200
      profile: "OPTIMIZE_UTILIZATION"
```

## Additional node pools
Define node pool with machine type g2-standard-4 and disk type pd-extreme that autoscales from 0 to 5 nodes.

```yaml
cluster:
  gcp:
    additionalNodePools:
      - name: "gpu-pool"
        machineType: "g2-standard-4"
        diskType: pd-extreme
        minCount: 0
        maxCount: 5
        labels:
          e2: true"
```

## Overprovision Pods
Create 5 pause pods that will request 1 CPU and 200Mi of memory. In total it will reserve 5 CPU and 1Gi of memory
```yaml
cluster:
  overprovisioning:
    replicas: 5
    cpu: "1"
    memory: "200Mi"
```
