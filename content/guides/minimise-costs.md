+++
title = "Enable Spot Instances"
weight = 400
chapter = false
pre = "11. "
+++

{{% notice warning %}}
Spot instances are not recommended for running workloads that are not fault tolerant.
{{% /notice %}}

{{% notice note %}}
Spot works well if you need to cut down costs for your clusters. See [minimising costs](../../platform/minimise-costs).
{{% /notice %}}


## Cluster setup with minimal costs
Create a cluster with Spot instances, HDD disk and `e2-medium` disk type.


```yaml
cluster:
  gcp:
    additionalNodePools:
      - name: "spot-pool"
        machineType: "e2-medium"
        diskType: "pd-standard"
        minCount: 0
        maxCount: 5
        spot: true

# Nodepool with 5 VMs using standard will cost $162 per month

# Nodepool with 5 VMs using spot nodes will cost $61 per month
```