+++
title = "Tenancy"
weight = 2
chapter = false
pre = ""
+++

A Tenancy is the unit of access to the developer platform. It contains readonly and admin group
and give you access to a namespace and a docker registry for images.
Once you have a tenancy you can add sub namespaces for all your application testing needs.

### Adding a tenancy

#### Using `corectl`
Run:
```shell
corectl tenant create
```

It will prompt you a series of questions about a new tenant. 
Once you fill the form, `corectl`
will create a PR in the [Environments Repo]({{< param environmentRepo >}}) with a new file for the tenancy.
Once PR is merged, a configuration for the new tenant will be provisioned automatically.

#### Manually

To add a tenancy raise a PR to the [Environments Repo]({{< param environmentRepo >}}) 
under `tenants/tenants/`

{{% notice note %}}
  Your tenancy name must be the same as the file name!
{{% /notice %}}

{{% notice note %}}
  Groups need to be in the `gke-security-groups` group!
{{% /notice %}}


For example, if I want to create a tenancy with the name `myfirsttenancy`, then I will create a file named `myfirsttenancy.yaml` with the following structure:

```yaml
name: myfirsttenancy 
parent: sandboxes
description: "IDP Reference Go Application"
contactEmail: idp-reference-application@{{< param email_org >}}
costCentre: platform
environments:
  - gcp-dev
repos:
  - https://github.com/<your-github-id>/idp-reference-app-go
adminGroup: platform-accelerator-admin@{{< param email_org >}}
readonlyGroup: platform-readonly@{{< param email_org >}}
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

* `name` - Name of your tenancy. Must be the same as your filename.
* `parent` -   #Explain what parent is and list possible values.
* `description` - Description for your tenancy.
* `contactEmail` - # Why do I need this? What is it used for?
* `costCentre` - # Why do I need this? What is it used for? In reference-app we have tenants and here platform
* `environments` which of the environments in [Environments Repo]({{< param environmentRepo >}}) you want to deploy to 
* `adminGroup` - will get permission to do all actions in the created namespaces
* `readonlyGroup` -  will get read only access to the created namespaces
* `repos` - Your [application](./new-app) URL. All `repos` GitHub actions will get permission to deploy to the created namespaces for implementing your application's [Path to Production](../p2p) aka CI/CD
* `cloudAccess` - generates cloud provider specific machine identities for kubernetes service accounts to impersonate/assume. Note that the `kubernetesServiceAccounts` are constructed like `<namespace>/<kubernetesServiceAccount>` so make sure these match with what your application is doing. This Kubernetes Service Account is controlled and created by the App and configured to use the GCP service account created by this configuration.
* `infrastructure` - allows you to configure projects to be attached to the current one's shared VPC, allowing you to use Private Service Access connections to databases in your own projects. This will attach your project to the one on the environment. 
* `betaFeatures` - enables certain beta features for tenants:
  * `k6-operator` - allows running tests with K6 Operator. 

{{% notice note %}}
  This attachment is unique, you can only attach your project to a single other project.
{{% /notice %}}
This means that if you want to have your databases in `gcp-dev` and `gcp-prod` for example, your tenant will need 2 GCP projects to attach to each environment.

## Accessing your namespaces

Once the above PR is merged everyone in the groups will have access to the namespaces created for that tenancy.

Based on the above example, we will have :

```
kubectl get namespace myfirsttenancy
NAME             STATUS   AGE
myfirsttenancy   Active   30s
```

With the [Hierarchical Namespace](https://kubernetes.io/blog/2020/08/14/introducing-hierarchical-namespaces/) kubectl plugin.

```
kubectl hns tree myfirsttenancy
myfirsttenancy
├── [s] myfirsttenancy-dev
├── [s] myfirsttenancy-functional
└── [s] myfirsttenancy-nft

[s] indicates subnamespaces
```

## Creating additional lightweight environments

You have permission to create as many lightweight environments in your tenancy.

All reference apps create at least:

* functional - for stubbed functional tests 
* nft - for stubbed functional tests

Typically, all lightweight environments are created in your dev cluster and only
a single namespace per application is in production.

To create a lightweight environment, in your tenancy namespace create:


```
apiVersion: hnc.x-k8s.io/v1alpha2
kind: SubnamespaceAnchor
metadata:
  namespace: {tenant_name}
  name: your-lightweight-env
```





