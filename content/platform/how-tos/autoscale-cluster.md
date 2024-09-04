+++
title = "Autoscale cluster"
weight = 4
chapter = false
pre = ""
+++

{{% notice warning %}}
Cluster autoscaling will not work unless resource requests for your workloads are defined. See [setting resource requests](../../app/how-tos/setting-resource-requests).
{{% /notice %}}

{{% notice note %}}
Nodes typically take up to 80 to 120 seconds to boot. If this is too long for you, see [overprovisioning](./overprovision-pods).
{{% /notice %}}

## Enable Autoscaling
Autoscaling can be enabled using the `config.yaml` file. See [cluster autoscaling](../cluster-autoscaling) for more details of how autoscaling works.

```yaml
cluster:
  gcp:
    autoscaling:
      cpuCores: 60
      memoryGb: 200
      profile: "OPTIMIZE_UTILIZATION"
```

## Disable Autoscaling
Simply remove `autoscaling` block from `config.yaml`

#### Before:
```yaml
cluster:
  gcp:
    autoscaling:
      cpuCores: 20
      memoryGb: 80
      profile: "OPTIMIZE_UTILIZATION"
    additionalNodePools:
      - name: "4-pool"
        diskType: "pd-standard"
        machineType: "e2-standard-4"
        minCount: 0
        maxCount: 5
```

#### After:
```yaml
cluster:
  gcp:
    additionalNodePools:
      - name: "4-pool"
        diskType: "pd-standard"
        machineType: "e2-standard-4"
        minCount: 0
        maxCount: 5
```

## Custom Node Pools
Define node pool with machine type `g2-standard-4` and disk type pd-extreme that autoscales from 0 to 5 nodes.

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
          e2: "true"
```
