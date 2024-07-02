+++
title = "DNS"
weight = 1
chapter = false
pre = ""
+++

The Developer Platform supports as many DNS Zones for regular Ingress.

Configure them in environment config.yaml e.g.

```
ingress_domains:
  - name: default
    domain: "gcp-dev.cecg.platform.cecg.io"
```

## DNS Zone delegation (per environment)

Before Ingress can function, you must delegate the configured zone to the Google nameservers.
These nameservers are not fixed, and can be seen after deployment of platform Ingress with the following command:

```
kubectl -n platform-ingress get dnsmanagedzones.dns.cnrm.cloud.google.com -o=jsonpath='{.items[0].status.nameServers}'
```

The output will look something like:

```
  * ns-cloud-e1.googledomains.com.
  * ns-cloud-e2.googledomains.com.
  * ns-cloud-e3.googledomains.com.
  * ns-cloud-e4.googledomains.com.
```

Once you have these values setup NS records in your DNS provider's configuration e.g.:

```
Type: NS	
Name: gcp-pre-dev.cecg.platform	
Value: 
  * ns-cloud-e1.googledomains.com.
  * ns-cloud-e2.googledomains.com.
  * ns-cloud-e3.googledomains.com.
  * ns-cloud-e4.googledomains.com.
```

## Default Zone

When your developer platform is initially deployed it comes with a zone under CECG's domain, including your organisation's `<name>`.
This is just to aid the initial developer experience and isn't intended for your production services.
The domains follow this structure:

`<name>.platform.cecg.io`

`<env>.<name>.platform.cecg.io`

`<name>` the name of the set of environments. Each set of environment typically is made up of pre-dev, dev, prod. 

`<env>` is the environment name within a developer platform.

For example, we (cecg) run our own instance of the core platform with a name of `cecg` so we will end up with:

* `sandbox.cecg.platform.cecg.io`
* `pre-dev.cecg.platform.cecg.io`
* `dev.cecg.platform.cecg.io`
* `prod.cecg.platform.cecg.io`

The `cecg.platform.cecg.io` is not currently managed so the user of the developer platform needs
to create and delegate every env's zone.