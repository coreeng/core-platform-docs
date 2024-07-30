+++
title = "Create Ingress with IP Whitelisting"
weight = 5
chapter = false
pre = ""
+++

{{% notice warning %}}
This uses beta features in the platform and breaking changes may occur in the future
{{% /notice %}}

## Create middleware
{{% notice note %}}
If on your resource you come across a `middleware.traefik.containo.us`, that is an older version of Treaefik's CRD. It will be deprecated in the future.
{{% /notice %}}

Create a `middleware.traefik.io` object to [whitelist IP addresses](https://doc.traefik.io/traefik/middlewares/http/ipwhitelist/):

```yaml
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: <middlewareName>
  namespace: <middlewareNamespace>
spec:
  ipWhiteList:
    ipStrategy:
      depth: 2 # depth is required as request is forwarded from load balancer. See https://doc.traefik.io/traefik/middlewares/http/ipwhitelist/#ipstrategydepth for more details
    sourceRange:
    - <ip-address>
    - <ip-address>
```

## Use Middleware in Ingress

Reference middleware in our Ingress object with the _annotation_ `traefik.ingress.kubernetes.io/router.middlewares: <middlewareNamespace>-<middlewareName>@kubernetescrd`, for example:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  labels:
  annotations:
    external-dns.alpha.kubernetes.io/hostname: foo.gcp-dev.cecg.platform.cecg.io # change this to point to your hostname
    external-dns.alpha.kubernetes.io/target: gcp-dev.cecg.platform.cecg.io # change this to point to your domain
    traefik.ingress.kubernetes.io/router.middlewares: <middlewareNamespace>-<middlewareName>@kubernetescrd
  name: foo-app
  namespace: foo
spec:
  ingressClassName: platform-ingress
  rules:
  - host: foo.gcp-dev.cecg.platform.cecg.io
    http:
      paths:
      - backend:
          service:
            name: foo-service
            port:
              number: 80
        path: /
        pathType: ImplementationSpecific
```

After you apply this, only users with whitelisted IPs will be able to use that ingress URL.

## Debugging

### Dashboard
To validate that your Middleware has been applied successfully, check the Traefik Dashboard and ensure that it contains no errors.

{{< figure src="/images/app/how-to/traefik-ipwhitelist-dashboard.png" title="Traefik Dashboard" >}}

### Logs
Check traefik logs to see whether request is being whitelisted:

{{< figure src="/images/app/how-to/traefik-logs.png" title="Traefik Logs" >}}
