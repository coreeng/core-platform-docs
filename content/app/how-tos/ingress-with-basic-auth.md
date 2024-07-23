+++
title = "Create Ingress with Basic Authentication"
weight = 5
chapter = false
pre = ""
+++

{{% notice warning %}}
This uses beta features in the platform and breaking changes may occur in the future
{{% /notice %}}

## What you need to know
To create ingress with out of the box basic authentication, you need to use the Traefik CRD `Middleware`.

## How does it work?
First we need to create a secret with a list of users we want to use:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: authsecret
  namespace: <namespace>
data:
  users: |2
    dGVzdDI6JGFwcjEkZVFFU0hOZEEkdi5ETFFJU1lOb0ZDVERuSlJiRmdQLwoK
    dGVzdDokYXByMSRMOGhDb0gySiR3emZUYkpDUEtndjlhZm0xdUtuRG8uCgo=
```

This contains 2 users, one on each line. The password here is expected to be encrypted and then the whole string encoded to base64. You can use the command `htpasswd -nb <user> <password> | openssl base64` to generate each user.

Then you need to create a `middleware.traefik.io` object. If on your resource you come across a `middleware.traefik.containo.us`, that is an older version of Treaefik's CRD. It will still work but it will be deprecated in the future.
The Middleware will look like this:

```yaml
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: <middleareName>
  namespace: <middlewareNamespace>
spec:
  basicAuth:
    secret: authsecret
```

After this, we can reference it in our Ingress object with the _annotation_ `traefik.ingress.kubernetes.io/router.middlewares: <middlewareNamespace>-<middleareName>@kubernetescrd`, for example:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  labels:
  annotations:
    external-dns.alpha.kubernetes.io/hostname: connected-app-functional-test.gcp-dev.cecg.platform.cecg.io
    external-dns.alpha.kubernetes.io/target: gcp-dev.cecg.platform.cecg.io
    traefik.ingress.kubernetes.io/router.middlewares: golang-auth-middleware@kubernetescrd
  name: connected-app-test
  namespace: connected-app-functional
spec:
  ingressClassName: platform-ingress
  rules:
  - host: connected-app-functional-test.gcp-dev.cecg.platform.cecg.io
    http:
      paths:
      - backend:
          service:
            name: connected-app-service
            port:
              number: 80
        path: /
        pathType: ImplementationSpecific
```

After you apply this, only the request authenticated with those users will be able to use that ingress URL.

## Debugging

To validate that your Middleware has been applied successfully, check the Traefik Dashboard and ensure that it contains no errors.

{{< figure src="/images/app/how-to/traefik-dashboard.png" title="Traefik Dashboard" >}}
