+++
title = "Platform Monitoring"
weight = 1
chapter = false
pre = ""
+++

## Platform Monitoring
Platform monitoring is a module deployed in the reference IDP that installs:
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
