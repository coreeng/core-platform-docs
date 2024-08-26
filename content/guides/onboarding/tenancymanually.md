+++
title = "Create Tenancy Manually"
weight = 150
chapter = false
pre = "1.2 "
+++


### Manually raising a PR for a new tenancy

If you haven't created a [tenancy using the CLI](../tenancycli) and want to add one manually, raise a PR to the Environments repository under `tenants/tenants/` in your platform environments repository.

{{% notice note %}}
Your tenancy name must be the same as the file name!
{{% /notice %}}


For example, if I want to create a tenancy with the name `myfirsttenancy`, then I will create a file named `myfirsttenancy.yaml` with the following structure:

```yaml
name: myfirsttenancy 
parent: sandboxes
description: "Go Application"
contactEmail: go-application@{{ email_org }}
costCentre: platform
environments:
  - gcp-dev
repos:
  - https://github.com/<your-github-id>/go-application
adminGroup: platform-accelerator-admin@{{ email_org }}
readonlyGroup: platform-readonly@{{ email_org }}
cloudAccess:
  - name: ca # Cloud Access. Keeping it short so the username is also short, biggest one will be ca-connected-app-functional which is 27 chars, for mysql 8.0 needs to be 32max. For 5.7 16 max
    provider: gcp
    kubernetesServiceAccounts:
    - <namespace>/<k8s_service_account_name>
infrastructure:
  network:
      projects:
      - name: name
        id: <project_id>
        environment: <platform_environment>
betaFeatures:
  - k6-operator
```


* `repos` - Your [application](../../deployapp) URL. All `repos` GitHub actions will get permission to deploy to the created namespaces for implementing your application's [Path to Production](.../../../../../p2p) aka CI/CD
* `cloudAccess` - generates cloud-provider-specific machine identities for kubernetes service accounts to impersonate/assume. Note that the `kubernetesServiceAccounts` are constructed like `<namespace>/<kubernetesServiceAccount>` so make sure these match with what your application is doing. This Kubernetes Service Account is controlled and created by the App and configured to use the GCP service account created by this configuration.
* `infrastructure` - allows you to configure projects to be attached to the current one's shared VPC, allowing you to use Private Service Access connections to databases in your own projects. This will attach your project to the one on the environment.
* `betaFeatures` - enables certain beta features for tenants:
  * `k6-operator` - allows running tests with K6 Operator.

{{% notice note %}}
This attachment is unique, you can only attach your project to a single other project.
{{% /notice %}}
This means that if you want to have your databases in `gcp-dev` and `gcp-prod` for example, your tenant will need 2 GCP projects to attach to each environment.

