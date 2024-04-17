+++
title = "Application Monitoring"
weight = 10
chapter = false
pre = ""
+++

## Accessing Grafana

### Via internal services

Grafana is available at `grafana`.`internal_services.domain`

The `internal_services.domain` is in the config.yaml for the environment you 
want to access grafana for in your [Environments Repo]({{< param environmentRepo >}}).

The currently deployed grafanas:

{{< grafanas >}}

### Via service port forwarding
```
kubectl -n platform-monitoring port-forward service/platform-grafana-service 3000
```

Then access [Grafana](http://localhost:3000)

#### How can I monitor application resources?

This dashboard will allow a team to monitori their application namespaces and check their status. It will show data like:
* CPU Usage
* Memory usage
* Pod status
* Pod restart count

{{< figure src="/images/platform-monitoring/namespace-dashboard.png" title="Namespace Dashboard" >}}

#### How can I monitor the whole cluster?

The global view dashboard will give you visibility over the cluster as a whole.
This will show you data like:
* Nodes status
* CPU and Memory usage
* CPU and Memory Limits
* CPU and Memory Reserved
* Pod and namespace count
* Pods status

{{< figure src="/images/platform-monitoring/global-dashboard.png" title="Global Dashboard" >}}


#### How can do I know if the environment is stable?

The platform-monitoring module also deploys continuous load. 
This will create k6 injectors and pods with `podinfo`, always with a stable throughput allowing us to monitor with enough data the different percentils and any errors that occur to ensure that we can be proactive in investigating and fixing any issues.

{{< figure src="/images/platform-monitoring/continuous-load-dashboard.png" title="Continuous load Dashboard" >}}
