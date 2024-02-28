+++
title = "Accessing Private Service Access"
weight = 10
chapter = false
pre = ""
+++


Your applications can be configured to be attached to the platforms shared VPC.

This can be enabled in your tenancy via adding the `infrstructure.network` section at the top level:

```yaml
infrastructure:
  network:
      projects:
      - name: name
        id: {{< param project_id >}}
        environment: {{< param environment >}}
```
This allows you to configure projects to be attached to the current one's shared VPC, allowing you use Private Service Access connections to databases in your own projects. This will attach your project to the the one on the environemnt. 
{{% notice note %}}
  This attachment is unique, you can only attach your project to a single other project.
{{% /notice %}}
This means that if you want to have your databases in `gcp-dev` and `gcp-prod` for example, your tenant will need 2 GCP projects to attach to each environment.

Creating and accessing a Database like Redis with PSA is simpler that cloudsql.
After you configure your tenancy network, you'll be able to create your redis instance. There, you'll chose `PRIVATE_SERVICE_ACCESS" as the connetion mode and configure the developer-platform's network as the authorized network which is constructed like
```
  projects/${platform_project_id}/global/networks/${platform_environment}-network"
```

Once configure and deployed, the redis instance will be given a private IP from the PSA range and you'll be able to reach it without any more configurations from your pods.