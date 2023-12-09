+++
title = "Deploy a reference app"
weight = 2
chapter = false
pre = ""
+++

You should have from the previous step:

* Environment: e.g. `gcp-dev`
* Tenancy e.g. `myfirsttenancy`
* Repo name e.g. `https://github.com/<your-github-id>/idp-reference-app-go`


If you plan to use the above forked repo, ensure your repos section from your tenancy yaml contains your above forked repo, for example:

```yaml
...
cost-centre: tenants
environments:
  - gcp-dev
repos: [https://github.com/<your-github-id>/idp-reference-app-go]
...
```

## Update the GitHub Variables

The following variable in GitHub needs to be set:

* `TENANT_NAME` from the tenancy you just created e.g. myfirsttenancy

Ones that are likely the same as the reference app you forked:

* `PROJECT_ID` from [Environments Repo]({{< param environmentRepo >}}) under `/environments/<env>/config.yaml`

* `PROJECT_NUMBER` from `gcloud projects describe $PROJECT_ID --format="value(projectNumber)`

* `BASE_URL` from `ingress_domains` in your [Environments Repo]({{< param environmentRepo >}}) under `/environments/<env>/config.yaml` .
 **Note** the `BASE_URL` should not include the first level of the subdomain. An example of BASE_URL is `cecg.platform.cecg.io`

* `ENV` which of the environments in [Environments Repo]({{< param environmentRepo >}}) you want to deploy to under `/environments/`

## Raise a PR

Raising a PR will automatically build the app, push the docker image, and deploy it to
environments for functional and non-functional testing.

{{% notice note %}}
If you have forked the reference app, then:

* You need to manually enable the workflows in your forked repository. To do this, navigate to your repository on GitHub. Click on the 'Actions' tab. If you see a notice about workflow permissions, click on 'I understand my workflows, go ahead and enable them'.

* In the Makefile of your repository, change the `tenant_name` variable to match the name of the tenancy you created."
{{% /notice %}}



## Merge the PR

Merges to main by default do the same as a PR, and additionally deploy to a stable dev namespace that
can be used for showcasing and integration testing.

Next [learn more about how to implement the P2P](../../p2p)
