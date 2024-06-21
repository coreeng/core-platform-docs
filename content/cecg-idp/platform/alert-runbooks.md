+++
title = "Alert runbooks"
weight = 10
chapter = false
pre = ""
+++

### Alerts runbooks

This contains a collection of runbooks that need to be followed for each alert raised on the platform.
Each alert should contain a short description and a deep link to the corresponding alert in this document.

##### KubePodCannotConnectToInternet

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

   Is that fails, check your NAT Gateway.

2. Is the Cloud NAT configured correctly?

##### ClusterAutoscalerNoScaleUp

Can't scale up because node auto-provisioning can't provision a node pool for the pod if it would exceed resource limits.

Node auto-provisioning did not provision any node pool for the pending pod in the zone because doing so would violate  resource limits.

Check GCP logs to get more details:

```
resource.type="k8s_cluster" AND
log_id("container.googleapis.com/cluster-autoscaler-visibility") AND
( "noScaleUp" )
```

Review and update cluster-wide minimal resource limits set for cluster auto-scaler.

##### KubeHpaReplicasMismatch

Horizontal Pod Autoscaler has not matched the desired number of replicas for longer than 15 minutes.
HPA was unable to schedule desired number of pods.

Check why HPA was unable to scale:

- not enough nodes in the cluster
- hitting resource quotas in the cluster
- pods evicted due to pod priority

In case of cluster-autoscaler you may need to set up preemptive pod pools to ensure nodes are created on time.

##### KubeHpaMaxedOut

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

