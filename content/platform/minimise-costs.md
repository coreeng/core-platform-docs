+++
title = "Minimise Costs"
weight = 1
chapter = false
pre = ""
+++

The platform allows you to optimise your infrastructure for maximum cost efficiency. In situations where you have multiple environments, some may be significantly underutilised.

You can run workloads while keeping its base cost low using [preemptible capabilities](https://cloud.google.com/compute/docs/instances/preemptible) offering 60-91% discount compared to standard virtual machines (VMs)

{{% notice note %}}
Default node pools hosting system pods run on standard VMs.
{{% /notice %}}

## Preemption

Preemptible instances work by using Compute Engine (CE) excess capacity. When CE needs to use some of that capacity for example during zonal outages, it will shut down preemptive to free up capacity.

### Limitations
- Preemptible instances are only run for 24 hours max. See [actions that reset 24 hour counter](https://cloud.google.com/compute/docs/instances/preemptible#preemption-selection)
- Preemptible instances are not always available
- Not covered by any Service Level Agreement (SLA)
- Compute Engine service may stop instances abruptly if capacity is required
- Cloud free tier credits do not count towards Preemptible Instances

To see more, check out [preemptible limitations](https://cloud.google.com/compute/docs/instances/preemptible)

## Cost comparison
The following parameters are provided for node pools:
- Number of instances: `5`
- Machine Type: `e2-standard-2`
- Boot Disk Type: `standard persistent disk`
- Boot Disk Size: `100GB`
- Region: `london`

```yaml
Standard VMs: $339

Preemptible VMs: $138
```
As you can see, preemptible VMs significantly reduce your costs

## Best Practices

- Pick smaller instance types to have a better chance of getting capacity
- Run preemptible on weekends or evenings (off peak hours)
- Design workloads to be fault tolerant e.g. stateless batch jobs

## Enable Preemptible Instances

See [preemptible instances](../how-tos/minimise-costs).
