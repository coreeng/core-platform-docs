+++
title = "Grafana"
weight = 1
chapter = false
pre = ""
+++

## Grafana

Grafana is installed using the grafana operator which manages the grafana instance, dashboards and datasources using CRDs.
CRDs API reference: https://grafana-operator.github.io/grafana-operator/docs/api/

To access it locally:
```
kubectl -n platform-monitoring port-forward svc/platform-grafana-service 3000
```

### Dashboards

Dashboards are automatically synced by the operator.
You can use the `grafanadashboard` resources to check its status and when it was last synced.  
```
kubectl -n platform-monitoring get grafanadashboard
NAME                    NO MATCHING INSTANCES   LAST RESYNC   AGE
bastion                                         42m           7h43m
continuous-load                                 2m17s         7h43m
kubernetes-apiserver                            42m           7h43m
[...]
```

When exporting dashboard json from Grafana, make sure special characters are replaced as follows
- replace `{{ target }}` with `{{ "{{" }} target {{ "}}" }}`
- replace `$somevar` with `${somevar}`

### Datasources

- Prometheus: points to the prometheus frontend to access all dashboard metrics 
- Alertmanager: points to the managed alertmanager to manage silences, view firing alerts, contact points, and notification policies