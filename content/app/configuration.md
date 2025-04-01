+++
title = "Configuration"
weight = 7
chapter = false
pre = ""
+++

Configuration should be injected to your application via environment variables.
Configuration can be broken into two categories:
  1) Common Configuration 
  2) Environment Specific Configuration

See [sensitive configuration](./secrets.md) for secrets.

## Common Configuration

- Add values to a file called `/config/common.yaml` to your repository.


In the format:

```yaml
service:
    environmentVariables: 
        MODE: default
        DATABASE_HOSTNAME: common-database-url
```

## Environment Specific Configuration

- Add an environment specific file called `/config/env.yaml` e.g. `/config/integration.yaml` to your repository.

```yaml
service:
    environmentVariables: 
        MODE: default
        DATABASE_HOSTNAME: integration-database-url
```


## Injecting the configuration 

Inject `.Values.service.environmentVariables` as environment variables to the application via a block in the `containers:` definition, in the _Deployment_ manifest, like:

```yaml
{{- if .Values.service.environmentVariables }}
          env:
            {{- range $key, $value := .Values.service.environmentVariables }}
            - name: {{ $key }}
              value: {{ $value }}
          {{- end }}
{{- end }}
```

### Pass the files to the helm install on deploy e.g.

```bash
deploy-integration:  
    helm upgrade --install $(app_name) helm-charts/app -n $(tenant_name)-integration \
        -f helm-charts/config/common.yaml \
        -f helm-charts/config/integration.yaml \
      ...
```
