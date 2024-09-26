+++
title = "Accessing Private Service Access"
weight = 11
chapter = false
pre = ""
+++


Your applications can be configured to be attached to the platforms shared VPC.

This can be enabled in your tenancy via adding the `infrastructure.network` section of your tenant definition in your platform environments repository at the top level:

```yaml
infrastructure:
  network:
      projects:
      - name: name
        id: <project_id>
        environment: <platform_environment>
```
This allows you to configure projects to be attached to the current one's shared VPC, allowing you to use Private Service Access connections to databases in your own projects. This will attach your project to the one on the environment. 
{{% notice note %}}
  This attachment is unique, you can only attach your project to a single other project.
{{% /notice %}}
This means that if you want to have your databases in `dev` and `prod` environments for example, your tenant will need 2 GCP projects to attach to each environment.

