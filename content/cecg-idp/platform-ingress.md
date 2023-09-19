+++
title = "Platform Ingress"
weight = 1
chapter = false
pre = ""
+++

## Platform Ingress
Platform Ingress is reponsible for creating the Ingress setup.


## Design
{{< figure src="/images/platform-ingress/idp-connectivity.png" title="Ingress design" >}}

### What does it include?
* Internal and public HTTP(S) load balancer
* Cloud DNS managed zones to manage the DNS
* External DNS
* 2 Traefik Ingress controllers, one for internal, and one for external traffic.

## How does DNS work?

Out of the box we will provide a subdomain of `corecicd.com`. If they have their own domain, that can be configured based on the `config.yaml`. The base construction will be:
`<environment>.<organization>.<ingressDomain>`, for example, `sandbox-gcp.cecg.corecicd.com`. The private URL construction will be the same, but prefixed with `internal`, for example `internal.sandbox-gcp.cecg.corecicd.com`.

The platform-ingress module install 2 Gateway objects that create GCP load balancers. The external creates a Global HTTP(S) load balancer and the internal one creates a Regional HTTP(S) internal load balancer. External DNS picks that up and registers them with A records with the LB IP. All other domains are registered as CNAME records pointing to the A records.

### How can I differentiate between internal and external

Each ingress controller will have its own ingress class. You'll have `platform-ingress` and `platform-ingress-internal` which can be defined in the `spec.ingressClassName`.
For external DNS to work, each ingress will need to have the annotations
```
annotations:
    external-dns.alpha.kubernetes.io/hostname: reference-app.sandbox-gcp.cecg.corecicd.com
    external-dns.alpha.kubernetes.io/target: sandbox-gcp.cecg.corecicd.com
```

### DNS delegation
How can clients manage records on a subdomain they do not own? We need to create a DNS delegation.
For `cecg` for example, we'll need to delegate that subdomain to `cecg` client. 
To do that, all you need to do is to create a NS record with the nameservers on the managed zone the `cecg` client created. 

{{< figure src="/images/platform-ingress/dns-delegation.png" title="DNS Delegation" >}}



## SSL
This will work out of the box until the LB and is coming soon.

## Example ingress
### External Ingress
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: reference-app-external
  annotations:
    external-dns.alpha.kubernetes.io/hostname: reference-app.sandbox-gcp.cecg.corecicd.com
    external-dns.alpha.kubernetes.io/target: sandbox-gcp.cecg.corecicd.com
  namespace: golang-dev
spec:
  ingressClassName: platform-ingress
  rules:
  - host: reference-app.sandbox-gcp.cecg.corecicd.com
    http:
      paths:
      - path: /hello
        pathType: Prefix
        backend:
          service:
            name: reference-service
            port:
              number: 80
```

### Internal Ingress
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: grafana
  annotations:
    external-dns.alpha.kubernetes.io/hostname: grafana.internal.sandbox-gcp.cecg.corecicd.com
    external-dns.alpha.kubernetes.io/target: internal.sandbox-gcp.cecg.corecicd.com
  namespace: platform-monitoring
spec:
  ingressClassName: platform-ingress-internal
  rules:
  - host: grafana.internal.sandbox-gcp.cecg.corecicd.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: platform-grafana-service
            port:
              number: 3000

```

## Future work
We aim to be tech agnostic and remove some redundancies, namely regarding external-dns annotations. For that wew ill create a mutating webhook that will inject the needed annotations based on the URL of the ingress.