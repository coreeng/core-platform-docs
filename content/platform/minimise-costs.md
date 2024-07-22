+++
title = "Minimise Costs"
weight = 1
chapter = false
pre = ""
+++

The platform allows you to optimise your infrastructure for maximum cost efficiency. There may be situations where you are running workloads where availability is not a priority e.g. lower environments.

Run workloads while keeping its base cost low using [spot capabilities](https://cloud.google.com/compute/docs/instances/spot) offering 60-91% discount compared to standard virtual machines (VMs)

{{% notice note %}}
Default node pools hosting system pods run on standard VMs.
{{% /notice %}}

## Spot Instances

These instances work by using Compute Engine (CE) excess capacity. When CE needs to use some of that capacity for example during zonal outages, it will shut down those instances to free up capacity.

### Limitations
- Spot instances are only available for [supported machine types](https://cloud.google.com/compute/docs/machine-resource#spot-machine-types)
- Spot instances are not always available
- Not covered by any Service Level Agreement (SLA)
- You cannot live migrated Spot Instances to Standard Instances
- Compute Engine service may stop instances abruptly if capacity is required
- Cloud free tier credits do not count towards Spot Instances

To see more, check out [spot limitations](https://cloud.google.com/compute/docs/instances/spot#limitations)

## Cost comparison

The following parameters are provided for node pools:
- Number of instances: `5`
- Machine Type: `e2-standard-2`
- Boot Disk Type: `standard persistent disk`
- Boot Disk Size: `100GB`
- Region: `london`

```yaml
Standard VMs: $339

Spot VMs: $138
```

Spot prices can change up to once every 30 days, but discounts for relevant resources are always in the 60-91% range.

## Best Practices

- Pick smaller instance types to have a better chance of getting capacity
- Run spot on weekends or evenings (off peak hours)
- Design workloads to be fault tolerant e.g. stateless batch jobs

## Enable Spot Instances

See [spot instances](../how-tos/minimise-costs).
