+++
title = "Cluster Autoscaling"
weight = 1
chapter = false
pre = ""
+++

The platform supports running wide range of workloads while keeping its base cost low.

It provides autoscaling capabilities so that it can adjust the capacity of the cluster to handle the required load.
When the load goes down, the cluster shrinks back to its normal size.

When running our platform on GCP/GKE we choose to operate clusters in [Standard mode](https://cloud.google.com/kubernetes-engine/docs/concepts/types-of-clusters#modes). 
You can read more about [pricing for Standard mode](https://cloud.google.com/kubernetes-engine/pricing#standard_mode) clusters.
To generate a cost estimate based on your projected usage, use the [pricing calculator](https://cloud.google.com/products/calculator).

## Node Pools

In order to run the platform and tenant pods we need to have worker nodes.

By default, we create just a small node pool to run platform system pods.
This pool will not be enough to run tenant workloads, so additional node pools need to be created via auto-provisioning and/or configured explicitly.

For GCP we recommend using [Node Auto-Provisioning](https://cloud.google.com/kubernetes-engine/docs/concepts/node-auto-provisioning) mode, so that GKE takes full control over node pools for running tenant workloads.

In special cases we allow Platform Operators to configure their node pools explicitly. Actually, nothing prevents them from running in a hybrid mode when general purpose nodes are provisioned automatically and
there are additional node pools with special machine types.

For the complete list of available machine types refer to Cloud Provider documentation, e.g. [Machine families resource and comparison guide](https://cloud.google.com/compute/docs/machine-resource) for GCP.

### Default node pool for platform pods

This is a small pool (1 node per zone) with `e2-standard-2` machine type.
By default, the platform system pods run there.

Assuming we are running a regional cluster with 3 zones, the minimal cost to operate the platform will be 3 nodes of `e2-standard-2` machine type.

### Autoscaling node pools with Node Auto-Provisioning

The default option to manage node pools for our platform running on GCP/GKE is Node Auto-Provisioning (NAP).

NAP allows us to support workloads with various CPU and memory requests by creating node pools with optimal machine types.

In order to enable Node Auto-Provisioning you should specify:
- number of CPU cores for the **whole** cluster
- number of gigabytes of memory for the **whole** cluster
- autoscaling profile

The available autoscaling profiles are:
- `BALANCED`: The default profile for Standard clusters.
- `OPTIMIZE_UTILIZATION`: Prioritize optimizing utilization over keeping spare resources in the cluster.
  When you enable this profile, the cluster autoscaler scales down the cluster more aggressively.
  GKE can remove more nodes, and remove nodes faster.

More about [Autoscaling profiles](https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-autoscaler#autoscaling_profiles).

The following example configuration will enable Node Auto-Provisioning for the cluster via `config.yaml`:

```yaml
cluster:
  gcp:
    autoscaling:
      cpuCores: 50
      memoryGb: 100
      profile: "OPTIMIZE_UTILIZATION"
```

### Explicit node pools configuration

This is discouraged, but available for users for which the default doesn't work.

To define a node pool we provide:
- machine type, e.g. `e2-standard-4`
- range for the number of nodes in the pool.
- optional taints and labels

{{% notice note %}}
We can't explicitly define max CPU or memory for the node, we can do it only by choosing the proper machine type.
{{% /notice %}}

The following is an example of an explicitly defined node pool with machine type `e2-standard-4` that 
autoscales from 0 to 5 nodes.

```yaml
cluster:
  gcp:
    additionalNodePools:
      - name: "4-pool"
        machineType: "e2-standard-4"
        minCount: 0
        maxCount: 5
```

GKE automatically creates new nodes in the pool until it reaches their maximum count.
When limit is reached newly deployed pods will stay in Pending state waiting for resources to become available.

In specific cases it is possible to combine NAP with explicit node pools configuration. For example,
we may need machines with special capabilities. While having common workloads scheduled on auto-provisioned nodes,
we may have custom node pools that are managed explicitly.

The following is an example of a hybrid configuration providing a node pool with special capabilities:

```yaml
cluster:
  gcp:
    autoscaling:
      cpuCores: 50
      memoryGb: 100
    additionalNodePools:
      - name: "g2-pool"
        machineType: "g2-standard-4"
        minCount: 0
        maxCount: 1
        labels:
          gpu: "true"
        taints:
          - key: "gpu"
            value: "true"
            effect: "NO_SCHEDULE"
```

## Cluster Overprovisioning

### Problem

When tenants are using Horizontal Pod Autoscaler (HPA) they may experience long delays between deploying a new Pod and actually running it.

Provisioning of a new node takes time, it can be up to several minutes. This may not be an issue for a background job, but can definitely affect the performance of an API
that needs to scale quickly to be able to handle traffic spikes.

### Solution

Overprovisioning can be configured using deployment running pause pods with very low assigned priority (see [Priority Preemption](https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/)) which keeps resources that can be used by other pods.
If there is not enough resources then pause pods are preempted and new pods take their place.
Next pause pods become unschedulable and force CA to scale up the cluster.

For more details refer to [FAQ: How can I configure overprovisioning with Cluster Autoscaler](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md#how-can-i-configure-overprovisioning-with-cluster-autoscaler).

The following example configuration will create 5 pause pods each requesting 1 CPU and 200Mi of memory:

```yaml
cluster:
  overprovisioning:
    replicas: 5
    cpu: "1"
    memory: "200Mi"
```

### Platform Cost vs Autoscaling Speed

Cluster Overprovisioning will make the scheduling of new Pods faster, but may require additional costs. 

There is a choice between keeping the operational cost of the platform low and reserving additional resources for faster autoscaling. 
