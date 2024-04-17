+++
title = "Expose your service via Ingress"
weight = 10
chapter = false
pre = ""
+++

To expose a HTTP service over TLS you add a Kubernetes Ingress resource e.g.

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    external-dns.alpha.kubernetes.io/hostname: reference-app-dev.gcp-dev.{{< param org >}}.platform.cecg.io
    external-dns.alpha.kubernetes.io/target: gcp-dev.{{< param org >}}.platform.cecg.io
  name: reference-service
  namespace: golang-dev
spec:
  ingressClassName: platform-ingress
  rules:
  - host: reference-app-dev.gcp-dev.{{< param org >}}.platform.cecg.io
    http:
      paths:
      - backend:
          service:
            name: reference-service
            port:
              number: 80
        path: /
        pathType: ImplementationSpecific
```

The important parts are:

* `external-dns.alpha.kubernetes.io/target` must match one of the ingress domains defined in [Environments Repo]({{< param environmentRepo >}})
* `external-dns.alpha.kubernetes.io/hostname` has to be a subdomain of the target
* `ingressClassName` must be platform-ingress 

Your service will now be available over the Internet over TLS.