+++
title = "Platform Troubleshooting"
weight = 10
chapter = false
pre = ""
+++

## Autoscaling failures

### 0/7 nodes are available: 7 Insufficient memory.

```
0/7 nodes are available: 7 Insufficient memory. preemption: 0/7 nodes are available: 1 Insufficient memory, 6 No preemption victims found for incoming pod.
```

Pods are stuck in `Pending` state. 

Total memory requests for pods have exceeded the maximum memory that is allowed as part of node autoscaling in the cluster. 

#### Resolution
Update `config.yaml` to increase the memory limit of the cluster autoscaling. Example:
```
cluster:
  gcp:
    autoscaling:
      cpuCores: 30
      memoryGb: 140
```

After the limits have been applied to the cluster, the pod should transition from `Pending` to `Running` state.

### 0/7 nodes are available: 7 Insufficient cpu.

```
0/7 nodes are available: 7 Insufficient cpu. preemption: 0/7 nodes are available: 1 Insufficient cpu, 6 No preemption victims found for incoming pod.
```

Pods are stuck in `Pending` state. 

Total cpu requests for pods have exceeded the maximum cpu that is allowed for node autoscaling.

### Resolution
Update `config.yaml` to increase the cpu limit of the cluster autoscaling. Example:
```
cluster:
  gcp:
    autoscaling:
      cpuCores: 60
      memoryGb: 140
```

## Node Imbalance
There are times where a node can be throttled e.g. 104% memory usage when other nodes have more than enough capacity to accomodate extra load 

## Deployment Failures

#### Local port [xxxx] is not available

A local port is used locally on the GitHub agent to IAP proxy to the Kubernetes API server. 
Sometimes a randomly selected port is not available.

#### Logs

```
2023-11-17T16:31:21.6142491Z --- Start tunnel (IAP)
2023-11-17T16:31:28.1159411Z ERROR: (gcloud.compute.start-iap-tunnel) Local port [57834] is not available.
```

#### Actions

The job can be re-run using re-run failed jobs

## Ingress / TLS Failures

#### A new ingress domain is not working 

When adding a new ingress domain the platform:
* Creates a Cloud DNS Managed Zone. You need to set up delegation for this domain so that Cloud DNS becomes the Name server. 


#### Actions

##### 1. Setup DNS Zone delegation for the new domain

See [dns delegation setup](../dns)

#### 2. Restart cert manager

Cert manager at times does not find the new Cloud DNS Zone. If this is the case you'll see cert manager logs like:

```
E1124 04:28:57.742110       1 controller.go:167] "cert-manager/challenges: re-queuing item due to error processing" err="No matching GoogleCloud domain found for domain XXXX.XX." key="platform-ingress/ingress-tls-secure-1-2070261079-2597927957"
```

Restarting cert manager:

```
kubectl delete pods -n platform-ingress -l app=cert-manager
```

On restarting the error should go away. If not, raise a support ticket with the logs for:

* External-DNS
* Cert Manager
* Output from:

```
kubectl get pods -n platform-ingress
kubectl get certificates -n platform-ingress
kubectl get certificaterequests -n platform-ingress
kubectl describe gateway traefik -n platform-ingress
```