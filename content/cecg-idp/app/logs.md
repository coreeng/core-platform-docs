+++
title = "Aggregated Logs"
weight = 9
chapter = false
pre = ""
+++

Open [Grafana](../app-monitoring) for your environment.

Go to `Explore` 

Set datasource to `Cloud Logging`

Select:
* `Log Bucket`: `_Default`
* `View`: `_AllLogs`

## Queries

### Get all logs for a given namespace

```
resource.type="k8s_container"
resource.labels.namespace_name="platform-ingress"
```

### Get all logs for a given container 

```
resource.type="k8s_container"
resource.labels.namespace_name="platform-ingress"
resource.labels.container_name="traefik"
```