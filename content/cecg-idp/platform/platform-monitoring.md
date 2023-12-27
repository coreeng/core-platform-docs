+++
title = "Platform Monitoring"
weight = 1
chapter = false
pre = ""
+++

## Platform Monitoring

Platform monitoring is responsible for ensuring the quality of the platform by providing visibility on the health of 
the platform and workloads running on it.
It allows both platform operators and application teams answer two basic questions: what's broken and why?

By collecting metrics from key platform components such as control plane, data plane, bastion as wells tenants workloads, 
platform monitoring allows operators and application teams to: 
- analyze after the facts (troubleshooting) or for long-term trends (e.g. how quickly is my database growing)
- compare impact of software changes when introducing a new feature or breaking one
- alert when something is broken or might break soon
- help answer basic questions about the health of the system using dashboards

### Platform Uptime

Platform uptime is measured by traffic continuously sent to an application deployed as part of the platform.

To view uptime for each environment:

{{< continuous-loads >}}

### Application resource monitoring

This dashboard will allow a team to monitor their application namespaces and check their status. It will show data like:
* CPU Usage
* Memory usage
* Pod status
* Pod restart count

{{< figure src="/images/platform-monitoring/namespace-dashboard.png" title="Namespace Dashboard" >}}

### Cluster wide resource monitoring

The global view dashboard will give you visibility over the cluster as a whole.
This will show you data like:
* Nodes status
* CPU and Memory usage, requests and limits
* Pod and namespace count
* Pods status

{{< figure src="/images/platform-monitoring/global-dashboard.png" title="Global Dashboard" >}}


### Cluster connectivity monitoring

The platform-monitoring module also deploys continuous load. 
This will create k6 injectors and pods with `podinfo`, always with a stable throughput allowing us to monitor with enough data the different percentils and any errors that occur to ensure that we can be proactive in investigating and fixing any issues.

{{< figure src="/images/platform-monitoring/continuous-load-dashboard.png" title="Continuous load Dashboard" >}}


### Platform liveness

Shows uptime and probe success rate and duration of key endpoints we monitor on the platform.
It can also be used to check SSL expiry.

**TODO upload new image here once we have traefik probes**

{{< figure src="/images/platform-monitoring/platform-liveness-dashboard.png" title="Platform liveness" >}}


### Platform alerts

#### Firing and silenced alerts 

**TODO review once we have the alert dashboard**

Firing alerts can be viewed in the Grafana UI either via the Alerts dashboard or via the built-in Alerting section.
Alerts can be silenced via the Alerting section by matching the alert(s) label that needs silencing.

{{< figure src="/images/platform-monitoring/alert-silencing.png" title="Alert silencing" >}}

#### Alert notifications

To send alerts to a dedicated slack channel, configure a [slack webhook](https://api.slack.com/messaging/webhooks) in your environment configuration:
```
platform_monitoring:
  slack_alert_webhook: https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX
```

