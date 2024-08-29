+++
title = "Create Tenancy with CLI"
weight = 100
chapter = false
pre = "1.1 "
+++

{{% notice warning %}}
**Prerequisites**
1) Configure [Core Platform CLI](../../../corectl).
{{% /notice %}}


### Adding a tenancy with corectl



The following corectl command will prompt you a series of questions about a new tenant. 
Once you fill the form, `corectl`
will create a PR in the Environments Repo with a new file for the tenancy.
Once the PR is merged, a configuration for the new tenant will be provisioned automatically.

You'll be prompted for:

* `tenant name` - Name of your tenancy.
* `parent tenant` - Name of the parent tenant or `root`. Note: `root` tenant is created implicitly.
* `description` - Description for your tenancy.
* `contactEmail` - Metadata: Who is the contact for this tenancy? 
* `costCentre` - Metadata: Used to split cloud costs. 
* `repositories` - (Optional) Your application repository for Core Platform. If you dont have one you can create after by following the guide for [Deploying a New Application](../../deployapp/) 
* `environments` which of the platform environments in Environments Repo you want to deploy to (select on or more with Space)
* `adminGroup` - will get permission to do all actions in the created namespaces
* `readonlyGroup` - will get read-only access to the created namespaces

```shell
corectl tenant create
```



{{% notice note %}}
Groups need to be in the `gke-security-groups` group!
{{% /notice %}}

