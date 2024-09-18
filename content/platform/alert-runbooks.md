+++
title = "Alert runbooks"
weight = 10
chapter = false
pre = ""
+++

### Alerts runbooks

This contains a collection of runbooks that need to be followed for each alert raised on the platform.
Each alert should contain a short description and a deep link to the corresponding alert in this document.

#### KubePodCannotConnectToInternet

1. Is this affecting pods network and node network too?

   Run a pod on the host network
    ```
    kubectl run testbox --rm -it --image ubuntu:18.04 --overrides='{ "spec": { "hostNetwork" : true }  }' -- /bin/bash 
    ```

   Then check you can reach the internet.
    ```
    apt-get update && apt-get install curl -y
    curl https://www.google.com
    ```

   Is that fails, check your NAT Gateway. Dashboard can be found in `platform-monitoring/NAT Gateway` dashboard in
   Grafana.

2. Is the Cloud NAT configured correctly?

#### KubePodCannotConnectToDeveloperPortal

Fires when the blackbox exporter is unable to connect to the developer portal.

1. Is the developer portal running?
   ```
   kubectl -n developer-portal get all
   ```

2. Are other alerts such as [`KubePodCannotConnectToInternet`](#kubepodcannotconnecttointernet) or [`ContainerInErrorState`](#containerinerrorstate) firing?

3. What is preventing the pod from running?  
   ```
   kubectl -n developer-portal logs deployment.apps/developer-portal
   ```

4. Are there errors relating to the database?

#### ClusterAutoscalerNoScaleUp

Node auto-provisioning did not provision any node pool for the pending pod because doing so would violate resource
limits.

For GCP/GKE, check logs to get more details:

```
resource.type="k8s_cluster" AND
log_id("container.googleapis.com/cluster-autoscaler-visibility") AND
( "noScaleUp" )
```

Review and update cluster-wide minimal resource limits set for cluster auto-scaler.

#### KubeHpaReplicasMismatch

Horizontal Pod Autoscaler has not matched the desired number of replicas for longer than 15 minutes.
HPA was unable to schedule desired number of pods.

Check why HPA was unable to scale:

- not enough nodes in the cluster
- hitting resource quotas in the cluster
- pods evicted due to pod priority

In case of cluster-autoscaler you may need to set up preemptive pod pools to ensure nodes are created on time.

#### KubeHpaMaxedOut

Horizontal Pod Autoscaler (HPA) has been running at max replicas for longer than 15 minutes.
HPA won’t be able to add new pods and thus scale application.

Notice: for some services maximizing HPA is in fact desired.

Check why HPA was unable to scale:

- max replicas too low
- too low value for requests such as CPU?

If using basic metrics like CPU/Memory then ensure to set proper values for `requests`.
For memory based scaling ensure there are no memory leaks.
If using custom metrics then fine tune how app scales accordingly to it.

Use performance tests to see how the app scales.

#### ContainerInErrorState

Container is not starting up, stuck in waiting state.

1. Identify which pod is causing the issue
   in grafana:
   ```
   https://<grafana_url>/explore?orgId=1&left=%7B%22datasource%22:%22gmp-datasource%22,%22queries%22:%5B%7B%22refId%22:%22A%22,%22editorMode%22:%22code%22,%22expr%22:%22sum%28kube_pod_container_status_waiting_reason%7Breason%20%21%3D%5C%22ContainerCreating%5C%22%7D%29%20by%20%28reason,%20pod%29%20%3E%200%22,%22legendFormat%22:%22__auto%22,%22range%22:true,%22instant%22:true%7D%5D,%22range%22:%7B%22from%22:%22now-1h%22,%22to%22:%22now%22%7D%7D)
   ```

2. What is preventing pod to start? Is the container in CrashLoopBackOff? Check pod events:
   ```
   kubectl -n <pod_namespace> describe pod <pod_name>
   ```
   If in CrashLoopBackOff state, check the process within the container is correctly configured. More info
   on debugging can be
   found in [GKE docs](https://cloud.google.com/kubernetes-engine/docs/troubleshooting#CrashLoopBackOff)

3. Is the image being pulled correctly? Check namespace events:
   ```
   kubectl -n <pod_namespace> get events --sort-by=.lastTimestamp
   ```
   If in ErrImagePull or ImagePullBackOff check if the container name is configured correctly and the tag exists in the
   registry. More info on debugging can be
   found in [GKE docs](https://cloud.google.com/kubernetes-engine/docs/troubleshooting#CrashLoopBackOff)

4. Can the pod be scheduled? Check request/limits on the container and ensure there is enough in the cluster. More info
   on debugging can be found
   in [GKE docs](https://cloud.google.com/kubernetes-engine/docs/troubleshooting#PodUnschedulable)

#### NatGatewayHighPortUtilisation

##### Meaning

High port utilisation by NAT Gateway, port allocation reached 70%. Each external IP address provides 64,512 available
ports that are shared by all VMs. Each port corresponds to a connection to unique destination address (IP:PORT:
PROTOCOL). When NAT Gateway runs out of free ports, it will start dropping outbound packets (requests going out to
the internet).

##### Impact

No outbound requests are affected at this point; however, you're getting closer to the limit. Once utilisation is closer
to 100%, some outbound requests will be affected.

{{% notice warning %}}
Utilisation doesn't have to reach 100% for requests to be affected. NAT Gateway will try to allocate at least the number
of ports specified in `network.publicNatGateway.minPortsPerVm` configuration. If there are not enough ports available to
satisfy this value, no ports will be allocated to VM in need.
{{% /notice %}}

##### Diagnosis & Mitigation

Follow [NAT Gateway IP Allocation Failures](./troubleshooting#nat-gateway-ip-allocation-failures) section.

#### NatGatewayIpAllocationFailed

##### Meaning

Failure in allocating NAT IPs to any VM in the NAT gateway. In result, services residing on affected VM's will not be
able to reach the internet. NAT Gateway allocates single IP to multiple VM's. When there are not enough available NAT
source IP addresses and source port tuples (IP:PORT:PROTOCOL), the NAT Gateway won't be able to service any new outbound
connections.

##### Impact

Some current outbound requests are affected.

##### Diagnosis & Mitigation

Follow [NAT Gateway IP Allocation Failures](./troubleshooting#nat-gateway-ip-allocation-failures) section.


#### ArgoCDApplicationIsNotHealthy

##### Meaning

One of the application components is not healthy, resulting in the whole application being marked as unhealthy.

##### Impact 

Tenant resources are allocated as the ArgoCD applications,
meaning that part of the tenant functionality might not be working as expected.
For example, some of the tenant permissions might be missing.

##### Diagnosis & Mitigation

1. Identify the problematic component by checking the ArgoCD UI: https://argocd.{{ internalServices.domain }}
2. Act accordingly to the error:
    - If the error is related to environment configuration, fix the configuration.
    - If the errors can be fixed by re-applying the manifests,
      you can do so by running Sync operation for the resource with `Replace` and `Force` options.
      Here is the [How-to](./how-tos/sync-argocd-app) on how to do it.
    - If it doesn't help, contact the Core Platform team.

#### ArgoCDApplicationIsNotSynced

##### Meaning

Application components state is different from the desired state.

##### Impact

Tenant resources are allocated as the ArgoCD applications,
meaning that part of the tenant functionality might not be working as expected.
For example, some of the tenant permissions might be missing.

##### Diagnosis & Mitigation

1. Identify the problematic component by checking the ArgoCD UI: https://argocd.{{ internalServices.domain }}
2. If the resource can't be updated because it's immutable,
   it's most probably a bug and should be fixed by Core Platform team. 
   But you can try to do a quick fix by syncing it with `Replace` and `Force` options via ArgoCD UI.
   Here is the [How-to](./how-tos/sync-argocd-app) on how to do it.
