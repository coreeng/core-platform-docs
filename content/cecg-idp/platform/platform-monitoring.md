+++
title = "Platform Monitoring"
weight = 1
chapter = false
pre = ""
+++

## Platform Monitoring

Platform monitoring is responsible for to scrape metrics on the cluster, apiServer and bastion and create out of the box dashboard. 
This will allow monitoring over the whole platform or a team to monitor their application resources.

### Platform Uptime

Platform up time is measured by traffic continuously sent to a application deployed as part of the platform.

To view uptime for each environment:

{{< continuous-loads >}}

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


#### How can do I know if my cluster connectivity is stable?

The platform-monitoring module also deploys continuous load. 
This will create k6 injectors and pods with `podinfo`, always with a stable throughput allowing us to monitor with enough data the different percentils and any errors that occur to ensure that we can be proactive in investigating and fixing any issues.

{{< figure src="/images/platform-monitoring/continuous-load-dashboard.png" title="Continuous load Dashboard" >}}



### What does it install
* IAM for managed prom
* Grafana operator 
* Grafana 
* Auth proxy to allow grafana to query prometheus
* Datasource for managed prometheus
* Dashboards


### Kube state metrics

Note that GMP re-labels `namespace` to `exported_namespace` as it reserves namespace for the namespace of the pod that
the metric is scraped from. When importing dashboards that rely on `kube-state-metrics` metrics, the queries must use `exported_namespace`.

## Grafana

Installed using the grafana operator then managing the grafana instance and CRDs as CRs.

Accessing:

```
kubectl -n platform-monitoring port-forward svc/platform-grafana-service 3000
```

Dashboards are from https://github.com/dotdc/grafana-dashboards-kubernetes

## GCP

In GCP Platform Monitoring depends on Prometheus Managed Collection being enabled.
