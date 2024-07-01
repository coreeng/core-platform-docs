+++
title = "Application Monitoring"
weight = 10
chapter = false
pre = ""
+++

# Generic Metrics

## Accessing Grafana

### Via internal services

Grafana is available at `grafana`.`internal_services.domain`

The `internal_services.domain` is in the config.yaml for the environment you
want to access grafana for in your Environments Repo.

You can quickly access it by running:
```bash
corectl env open <env> grafana
```

### Via service port forwarding

```
kubectl -n platform-monitoring port-forward service/platform-grafana-service 3000
```

Then access [Grafana](http://localhost:3000)

#### How can I monitor application resources?

This dashboard will allow a team to monitor their application namespaces and check their status. It will show data
like:

* CPU Usage
* Memory usage
* Pod status
* Pod restart count

{{< figure src="images/platform-monitoring/namespace-dashboard.png" title="Namespace Dashboard" >}}

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

The platform-monitoring module also deploys a continuous load.
This will create k6 injectors and pods with `podinfo`, always with a stable throughput allowing us to monitor with
enough data the different percentils and any errors that occur to ensure that we can be proactive in investigating and
fixing any issues.

{{< figure src="/images/platform-monitoring/continuous-load-dashboard.png" title="Continuous load Dashboard" >}}

# Application-Specific Metrics

Examples of Application-Specific Metrics:

- Go GC statistics
- Request processing latency
- Number of processed jobs

## Prerequisite

You should have deployed monitoring stack for your tenant.
This monitoring stack consists of preconfigured Grafana and Prometheus instances.
To install monitoring stack, run the following command:

```bash
# Add helm repository
helm repo add coreeng https://coreeng.github.com/core-platform-assets
helm repo update

# Install the chart
helm -n {{ target-ns }} install monitoring-stack coreeng/monitoring-stack --set tenantName={{ your-tenant-name }}
```

Here:
- `your-tenant-name` - name of the tenancy to be monitored. Prometheus will look for PodMonitors/ServiceMonitors in
  subnamespaces of this tenant.


## Monitoring Application

To monitor start monitoring your application,
you have to create `ServiceMonitor` or `PodMonitor` resource for your application
and put `monitoring/instance:: {{ your-tenant-name }}` label on it.
By using tenant label, you define the target prometheus instance.
Here is the example:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: some-service
  labels:
    app.kubernetes.io/name: some-service
    monitoring/instance: {{ your-tenant-name }}
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: some-service
  endpoints:
    - interval: 30s
      port: metrics
      path: /metrics
```

This configuration assumes that your application exposes metrics on `metrics` endpoint in Prometheus format.

## Accessing Grafana and Prometheus

Grafana and Prometheus are not exposed by default. You have two options:

- Create Ingress resources for internal domain
- Port forward Grafana and Prometheus

### Through Ingress

To enable ingress for monitoring services,
you have to set the respective values during the installation of the monitoring-stack chart.
It should look like this:
```bash
helm -n {{ target-ns }} install monitoring-stack coreeng/monitoring-stack \
    --set tenantName={{ your-tenant-name }} \
    --set internalServicesDomain={{ internal-services-domain }} \
    --set prometheus.ingress.enabled=true \
    --set grafana.ingress.enabled=true
```

Here:

- `internal-services-domain` - domain of the internal services: `internal_services.domain`

Grafana should be accessible by the URL: `{{ your-tenant-name }}-grafana.{{ internal-services-domain }}`
Prometheus should be accessible by the URL: `{{ your-tenant-name }}-prometheus.{{ internal-services-domain }}`

### Through port forward

To port forward Grafana, run the command below and access it on [http://localhost:3000](http://localhost:3000)

```bash
kubectl -n {{ target-ns }} port-forward service/grafana-{{ your-tenant-name }}-service 3000
```

To port forward Prometheus, run the command below and access it on [http://localhost:9090](http://localhost:9090):

```bash
kubectl -n {{ target-ns }} port-forward service/prometheus-{{ your-tenant-name }} 9090
```

## Creating Grafana Dashboards

To create Grafana Dashboard you have to create `GrafanaDashboard` CR.
If you create it directly with UI, the changes will not be persisted for long,
so it's advised to use Grafana UI for designing your Dashboard and then export it to CR.

When creating GrafanaDashboard, you have to specify Grafana instance selector, so Grafana Operator can inject your
dashboard in Grafana instance:

```yaml
  instanceSelector:
    matchLabels:
      grafana: grafana-{{ your-tenant-name }}
```

In addition, in case your GrafanaDashboard is not in the same namespace as your monitoring stack, you have to specify an additional field:
```yaml
  allowCrossNamespaceImport: "true"
```
