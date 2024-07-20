+++
title = "Enable Preemptible Instances"
weight = 4
chapter = false
pre = ""
+++

{{% notice warning %}}
Preemptible instances are not recommended for running workloads that are not fault tolerant. Instances will only run for 24 hours and will be turned off afterwards.
{{% /notice %}}

{{% notice note %}}
Preemption works well if you need to cut down costs for your clusters. See [minimising costs](../../minimise-costs).
{{% /notice %}}


## Cluster setup with minimal costs
Create a cluster with autoscaling disabled, preemptible nodes, HDD disk and `e2-medium` disk type.


```yaml
cluster:
  gcp:
    additionalNodePools:
      - name: "preempt-pool"
        machineType: "e2-medium"
        diskType: "pd-standard"
        minCount: 0
        maxCount: 5
        preemptible: true

# Nodepool with 5 VMs using standard will cost $162 per month

# Nodepool with 5 VMs using premptible nodes will cost $61 per month
```