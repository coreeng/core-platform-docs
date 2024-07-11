+++
title = "Autoscale cluster"
weight = 4
chapter = false
pre = ""
+++

{{% notice warning %}}
Cluster autoscaling will not work unless resource requests for your workloads are defined. See [setting resource requests](../../../app/how-tos/setting-resource-requests)
{{% /notice %}}

{{% notice note %}}
Nodes typically take up to 80 to 120 seconds to boot. If this is too long for you, see [overprovisioning](../overprovision-pods)
{{% /notice %}}

## Autoscale nodes
Autoscaling can be enabled using the `config.yaml` file. See [cluster autoscaling](../../cluster-autoscaling) for more details of how autoscaling works.

```yaml
cluster:
  gcp:
    autoscaling:
      cpuCores: 60
      memoryGb: 200
      profile: "OPTIMIZE_UTILIZATION"
```

## Custom node pools
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


c