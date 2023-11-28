+++
title = "Alerting"
weight = 1
chapter = false
pre = ""
+++

## Alerting

### Alert manager

Managed alertmanager is a single replica statefulset deployed with [Google Managed Prometheus](https://cloud.google.com/stackdriver/docs/managed-prometheus). 
It receives alerts from the rule evaluator and sends notification to configured receivers.

### Alerts definitions

Alerts are defined using [Rules](https://github.com/GoogleCloudPlatform/prometheus-engine/blob/v0.7.4/doc/api.md#rules), [ClusterRules](https://github.com/GoogleCloudPlatform/prometheus-engine/blob/v0.7.4/doc/api.md#clusterrules) or [GlobalRules](https://github.com/GoogleCloudPlatform/prometheus-engine/blob/v0.7.4/doc/api.md#globalrules).

Rules [spec](https://github.com/GoogleCloudPlatform/prometheus-engine/blob/v0.7.4/doc/api.md#rulesspec) follows the same format as a prometheus rules files,
which makes it possible to test using [promtool](https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules/) 
To view alert rules, run
```
kubectl -n platform-monitoring describe rules
```
