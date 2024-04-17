+++
title = "Deploy a new application"
weight = 3
chapter = false
pre = ""
+++

## Create a new application
### Using `corectl`
Run:
```shell
corectl app create <new-app-name> [<new-app-dir>]
```
It will:
- prompt you a few additional questions, including template for the application.
- create a new repository using the selected template
- configure the created GitHub repository, so P2P workflows will run without an issue

### Manually

You should have from the previous step:
* Tenancy e.g. `myfirsttenancy`
* Environment: e.g. `gcp-dev`

Create a new repository by forking a
[Golang Reference](https://github.com/{{< param github_org >}}/idp-reference-app-go)
or by creating a new repository from template using `corect template render...`.
For the P2P workflows to work you need to have this repository to be present in `environments` list in the tenant file.
For example
```yaml
...
cost-centre: tenants
environments:
  - gcp-dev
repos: [https://github.com/<your-github-id>/<your-new-repository>]
...
```

#### Update the GitHub Variables

The following variable in GitHub needs to be set:

* `TENANT_NAME` from the tenancy you just created e.g. myfirsttenancy

Ones that are likely the same as the reference app you forked:

* `PROJECT_ID` from [Environments Repo]({{< param environmentRepo >}}) under `/environments/<env>/config.yaml`

* `PROJECT_NUMBER` from `gcloud projects describe $PROJECT_ID --format="value(projectNumber)"`

* `BASE_URL` from `ingressDomains` in your [Environments Repo]({{< param environmentRepo >}}) under `/environments/<env>/config.yaml`.
 **Note** the `BASE_URL` should not include the first level of the subdomain. An example of BASE_URL is `cecg.platform.cecg.io`

* `INTERNAL_SERVICES_DOMAIN` from `internalServices` [Environments Repo]({{< param environmentRepo >}}) under `/environments/<env>/config.yaml`.

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
