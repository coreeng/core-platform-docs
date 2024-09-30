+++
title = "Identity Provider Login for Internal Services"
weight = 5
chapter = false
pre = ""
+++

Internal services such as:

* Grafana
* Platform Docs

Are exposed with Identity Provider login, currently only Google Gsuite is supported.

## Configuring the domain for internal services

In your environment configuration

```yaml
internal_services:
  name: secure
  domain: "gcp-dev-internal.cecg.platform.cecg.io"
```

The domain must be different from your ingress_domains.

DNS delegation for that domain should be configured as in [DNS](./dns)
