+++
title = "Deploy a New Application with CLI"
weight = 300
chapter = false
pre = "2.1 "
+++
{{% notice warning %}}
**Prerequisites**

1) Configure the [Core Platform CLI](../../corectl/).
2) Complete the [Onboarding Tenancy](../onboarding/).
{{% /notice %}}
## Create a New Application

First update the corectl config :

```bash
corectl config update
```

To create a new application, use the following corectl command:


`<new-app-name>`: Your application's name. This will create a GitHub repository with the pattern `<github_org>/<new-app-name>`.


`<new-app-dir>`: (Optional) If specified, this will create a local directory named <new-app-dir>. If not specified, a directory with the name <new-app-name> will be created.

You'll be prompted for:

* A template for your application. You can choose one of the following options:

    * empty: An empty application for the Core Platform with no continuous delivery configured.
    * blank: A blank application for the Core Platform with continuous delivery configured.
    * go-web: A Go web application for the Core Platform with continuous delivery configured.
    * java-web: A Java web application for the Core Platform with continuous delivery configured.

* Your tenancy: Select the tenancy you created during the [Oborading Tenancy](../../onboarding) process.



```bash
corectl app create <new-app-name> [<new-app-dir>]
```

{{% notice note %}}
To complete the application onboarding to the Core Platform, you must first review and merge the pull request (PR)in the repository where you manage tenants.
{{% /notice %}}

Once the above steps are completed and the PR is merged, you will have:

* A repository: `https://github.com/<github_org>/<new-app-name>` that is fully configured for continuous delivery under your tenancy, including:
  * Versioning
  * Functional testing
  * Non-functional testing
  * Promotion between a set of standard environments
  * Deployment to production

* An application ready to deploy to production on every commit!

## Raise a Pull Request (PR)

Raising a Pull Request (PR) will automatically trigger the following actions:

- Build the application.
- Push the Docker image.
- Deploy the application to tenant environments for both functional and non-functional testing.

## Merge the Pull Request (PR)

Merging the Pull Request (PR) into the main branch will, by default, perform the same actions as raising a PR. 

Additionally, it will deploy the application to a stable dev namespace. This stable environment can be used for:

- Showcasing
- Integration testing

For more information, you can [learn how to implement the P2P process](../../../../p2p).

