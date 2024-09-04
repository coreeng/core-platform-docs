+++
title = "Application Autoscaling"
weight = 10
chapter = false
pre = ""
+++

{{% notice note %}}
Make sure that [resource requests](./resources) are defined for the application. Autoscalers use them as a base-line to calculate utilization.
{{% /notice %}}

Applications are scaled vertically or horizontally to be able to handle the increasing load. 
When traffic goes up, you add more resources (CPU and/or memory) and/or deploy more replicas.
When traffic goes down, you revert back to the initial state to minimise costs.
This can be done automatically with Kubernetes based on resource utilization.

This section describes autoscaling mechanisms and provides some [guidelines](#guidelines) on how to scale an app with Core Platform.  

## Autoscalers

Kubernetes provides [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) (HPA) and [Vertical Pod Autoscaler](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler) (VPA) as out-of-the-box tools for scaling deployments:
- **HPA** - for stateless workloads
- **VPA** - for stateful and long-running workloads

### Horizontal Pod Autoscaler (HPA)

Horizontal scaling response to increased load is to deploy more pods.
If the load decreases, HPA instructs the deployment to scale back down.

Below is an example of HPA configuration for the Reference app to scale based on CPU Utilization. (We can use other resources e.g. memory utilization or a combination of them)
We specify the range for the number of replicas, [resources and thresholds](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#support-for-resource-metrics) when HPA should be triggered. 

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: reference-app
  labels:
    app.kubernetes.io/name: reference-app
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: reference-app
  minReplicas: 1
  maxReplicas: 30
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 60
```

We can also affect how fast the application scales up by modifying [scaling behavior](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#configurable-scaling-behavior). This policy allows pods to scale up 1000% every 15 seconds. 

```yaml
  behavior:
    scaleUp:
      policies:
        - type: Percent
          value: 1000
          periodSeconds: 15
```


### Vertical Pod Autoscaler (VPA)

Automatically adjusts the amount of CPU and memory requested by pods.
VPA provides recommendations for resource usage over time, it works best with long-running homogenous workloads.
It can both down-scale pods that are over-requesting resources, and also up-scale pods that are under-requesting resources based on historical usage.

There are four modes in which VPA operates: `Auto`, `Recreate`, `Initial`, `Off`. Refer to [VPA docs](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#quick-start) for more details.

Below is an example of VPA configuration for the reference app running in `Off` mode:

```yaml
apiVersion: autoscaling.k8s.io/v1beta2
kind: VerticalPodAutoscaler
metadata:
  name: reference-app
  labels:
    app.kubernetes.io/name: reference-app
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: reference-app
  updatePolicy:
    updateMode: "Off"
```

It is advised to start with `Off` mode when VPA does not automatically change the resource requirements of the pods.
The recommendations are calculated and can be inspected in the VPA object.
After the validation we can switch the `updateMode` to `Auto` to allow applying recommendations to resource requests.

### Combining HPA & VPA

VPA should not be used with the HPA on the same resource metric (CPU or memory) [at this moment](https://github.com/kubernetes/autoscaler/blob/master/multidimensional-pod-autoscaler/AEP.md).
Due to the independence of these two controllers, when they are configured to optimise the same target, e.g., CPU usage, they can lead to an awkward situation where HPA tries to spin more pods based on the higher-than-threshold CPU usage while VPA tries to squeeze the size of each pod based on the lower CPU usage (after scaling out by HPA).

However, you can use VPA with HPA on separate resource metrics (e.g. VPA on memory and HPA on CPU) as well as with HPA on custom and external metrics.

## Guidelines

To autoscale, we need to start by defining non-functional requirements for the application. 

For example, we require:
- the application to handle 30k TPS with P99 latency < 500 ms.
- there are spikes when traffic ramps up linearly from 0 to max in 3 minutes.

We choose which autoscaling mechanism to use:
- To handle traffic spikes with a stateless app we should consider using HPA. 
- We choose VPA for stateful long-running homogenous workloads. 

We prepare [NFT](../p2p/fast-feedback/p2p-nft) scenarios to validate that the application meets the requirements for the load. 
We need to repeatedly run the tests to adjust the resource requests and fine-tune the thresholds to handle the required traffic patterns.

The following is a list of recommendations that can be applied to improve the results of the test:

- Ensure the load generator (e.g. K6) have enough resources and connections to generate the load.
- If Platform Ingress is a bottleneck then ask Platform Operators to check [Traefik resources and autoscaling configuration](../platform/platform-ingress#autoscaling).
- If pods are stuck in Pending state then ask Platform Operators to check [Cluster Autoscaling configuration](../platform/cluster-autoscaling) to make sure it has enough resources.
- If pods are stuck in Pending state, slowing down the autoscaling, then you may need to over-provision resources. Ask Platform Operators to check [Cluster Overprovisioning configuration](../platform/cluster-autoscaling#cluster-overprovisioning).
- If the app is dying due to OOM, you may need to give more memory and/or increase the minimum number of replicas.
- If the app is not responding to readiness/liveness probes, you need to give more CPU and/or increase the minimum number of replicas.
- If the app is not scaling-up fast enough, then you may need to lower the thresholds for resource utilization and/or adjust scaling behavior (see HPA configuration).

After you changed the parameters you need to re-run the test and validate the results.
As for any type of performance testing, try changing only one parameter at a time to assess the impact correctly.

### Dashboards

There are several dashboards that can help you better understand the behavior of the system:
- Kubernetes / Views
- Traefik Official Kubernetes Dashboard
- Reference App Load Testing


Refer to [Application Monitoring](./app-monitoring) and [Platform Monitoring](../platform/platform-monitoring) sections for more details.
