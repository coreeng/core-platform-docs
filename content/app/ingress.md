+++
title = "Expose your service via Ingress"
weight = 10
chapter = false
pre = ""
+++

To expose an HTTP service over TLS, you add a Kubernetes Ingress resource, e.g.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    external-dns.alpha.kubernetes.io/hostname: {{ service-host }}
    external-dns.alpha.kubernetes.io/target: {{ ingress-host }}
  name: reference-service
  namespace: golang-dev
spec:
  ingressClassName: platform-ingress
  rules:
  - host: {{ service-host }}
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

* `external-dns.alpha.kubernetes.io/target` must match one of the ingress domains defined in environment config yaml file in Environments Repo
* `external-dns.alpha.kubernetes.io/hostname` has to be a subdomain of the target
* `ingressClassName` must be platform-ingress

Your service will now be available over the Internet over TLS.

To have a deeper understanding of how the Platform Ingress feature is designed, check the [Platform Ingress Overview.](../platform/platform-ingress)
