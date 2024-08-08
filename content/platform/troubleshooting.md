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
There are times where a node can be throttled e.g. 96% memory usage when other nodes have more than enough capacity to accomodate extra workloads.

It is highly likely that pods running on that node do not have memory/cpu requests set. This causes kube scheduler to place significant load on one node as it uses the requests to target what nodes pods should be placed on.

### Resolution
Set [resource requests](../../app/resources) for your application workloads to allow the kube scheduler better place your pods on nodes with appropiate capacity. For example if you request 2Gi memory for your pod, the scheduler will guarantee finding a node that has that capacity. 

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


#### IPs not being whitelisted by traefik
You have configured to whitelist IPs using traefik middlewares but are still getting forbidden when accessing endpoints from a valid IP address.

##### Enable JSON logs
Edit traefik deployment to add the arguments:
```
kind: Deployment
metadata:
  name: traefik
  namespace: platform-ingress
...
spec:
    containers:
    - args:
      - --log.level=DEBUG
      - --log.format=json
      - --accesslog=true
      - --accesslog.format=json
```

#### View traefik logs

```yaml
kubectl logs -f deployment/traefik -n platform-ingress

Logs:

{"level":"debug","middlewareName":"platform-ingress-ready-ipwhitelist@kubernetescrd","middlewareType":"IPWhiteLister","msg":"Accepting IP 86.160.248.78","time":"2024-08-07T22:03:23Z"}
```

##### Check Load Balancer logs
On the Google Console navigate to Logging Explorer navigate and run the following query
```
resource.type="http_load_balancer" resource.labels.project_id="<your-gcp-project-id>"
```

{{< figure src="/images/troubleshooting/loadbalancer_logs.png" title="Load Balancer Logs" >}}


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
