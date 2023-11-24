+++
title = "Metrics collection"
weight = 1
chapter = false
pre = ""
+++

## Metrics collection

The platform uses [Google Managed Prometheus](https://cloud.google.com/stackdriver/docs/managed-prometheus)
which comes with a scalable backend prometheus storage and metrics collectors that scrape exposed metrics endpoints
such as kubelet/cadvisor and kube state metrics via CRDs.
CRDs are defined here: https://github.com/GoogleCloudPlatform/prometheus-engine/blob/v0.7.4/doc/api.md

### Kube state metrics - [docs](https://github.com/kubernetes/kube-state-metrics)

Generates metrics from a wide range of Kubernetes objects.
These can be used to assess the health of your pods, deployment, jobs and many other Kubernetes objects.

They generally start with `kube_`.

Note that GMP re-labels `namespace` to `exported_namespace` as it reserves namespace for the namespace of the pod that
the metric is scraped from. When importing dashboards that rely on `kube-state-metrics` metrics, the queries must use `exported_namespace`.

### cadvisor - [docs](https://github.com/google/cadvisor)

Collects metrics for containers running on the node ; it runs alongside kubelet on each node.
Typical metrics include cpu, memory, I/O usage which can be used to diagnose performance issues.

They generally start with `container_`

### kubelet - [docs](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/)

kubelet is the agent running on the node that is responsible to ensure containers are running and healthy.
Collected metrics can be used to identify pod start duration, the number of pods and containers on the node
and other information about the node, such as status

### Blackbox exporter - [docs](https://github.com/prometheus/blackbox_exporter)

This is used to probe key endpoints on or outside the platform, so we can monitor uptime and SSL expiry of components with TLS termination.
