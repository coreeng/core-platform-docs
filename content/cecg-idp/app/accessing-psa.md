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
        id: <project_id>
        environment: <platform_environment>
```
This allows you to configure projects to be attached to the current one's shared VPC, allowing you use Private Service Access connections to databases in your own projects. This will attach your project to the the one on the environemnt. 
{{% notice note %}}
  This attachment is unique, you can only attach your project to a single other project.
{{% /notice %}}
This means that if you want to have your databases in `gcp-dev` and `gcp-prod` for example, your tenant will need 2 GCP projects to attach to each environment.

