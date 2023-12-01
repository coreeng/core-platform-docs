+++
title = "Deploy a reference app"
weight = 2
chapter = false
pre = ""
+++

You should have from the previous step:

* Environment: e.g. `gcp-dev`
* Tenancy e.g. `auth`
* Repo name e.g. `https://github.com/{{< param github_org >}}/auth`

Fork a Developer platform reference app:

* [Golang Reference](https://github.com/{{< param github_org >}}/idp-reference-app-go)

If you plan to use the above forked repo, ensure your repos section from your tenancy yaml contains your above forked repo, for example:

```yaml
...
cost-centre: tenants
environments:
  - gcp-dev
repos: [https://github.com/coquinncecg/idp-reference-app-go]
...
```

## Update the GitHub Variables

The following variable in GitHub needs to be set:

* `TENANT_NAME` from the tenancy you just created

Ones that are likely the same as the reference app you forked:

* `PROJECT_ID` from [Environments Repo]({{< param environmentRepo >}})
* `PROJECT_NUMBER` from [Environments Repo]({{< param environmentRepo >}})
* `BASE_URL` from `ingress_domains` in your [Environments Repo]({{< param environmentRepo >}})
* `ENV` which of the environments in [Environments Repo]({{< param environmentRepo >}}) you want to deploy to

## Raise a PR

Raising a PR will automatically build the app, push the docker image, and deploy it to
environments for functional and non-functional testing.

## Merge the PR

Merges to main by default do the same as a PR, and additionally deploy to a stable dev namespace that
can be used for showcasing and integration testing.

Next [learn more about how to implement the P2P](../../p2p)
