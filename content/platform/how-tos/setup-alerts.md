+++
title = "Setup Alerts"
weight = 4
chapter = false
pre = ""
+++

{{% notice note %}}
Alerts on key metrics can be useful to reduce your time to detection of issues. See [Platform Monitoring](../platform-monitoring) for what type of dashboards and metrics are available on the platform.
{{% /notice %}}

## Alert notifications

To send alerts to a dedicated slack channel, configure a [slack webhook](https://api.slack.com/messaging/webhooks) in your `config.yaml`:

```yaml
platform_monitoring:
  slack_alert_webhook: https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX
```
