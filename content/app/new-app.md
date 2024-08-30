+++
title = "Deploy a new application"
weight = 3
chapter = false
pre = ""
+++

## Create a new application

The Core Platform with a single command will configure:

* A new repository
* A template application demonstrating full continous delivery:
  * Versioning 
  * Functional testing
  * Non-functional testing
  * Promotion between a set of standard environments
  * Deployment to production

After running this command, and triggering the resulting GitHub workflow you'll have an
application ready to deploy to production on every commit!

```shell
corectl app create <new-app-name> [<new-app-dir>]
```
It will:
- prompt you a few additional questions, including template for the application.
- create a new repository using the selected template
- configure the created GitHub repository, so P2P workflows will run without an issue

### Create an application as part of a monorepo

Instead of creating a new repository for each of the applications, you can create a single repository
and add the applications as sub-directories.

First create a new root repository 

```shell
corectl app create <new-monorepo-name> --tenant <tenant-name> --nonint
```

This will create an empty repository with necessary variables preconfigured for the P2P to work.

Now create a new application in the sub-directory. You will be prompted for a template to use.

```shell
cd <new-monorepo-name>
corectl app create <new-app-name> --tenant <sub-tenant-name>
```

Your new application will be created in a new PR for a monorepo. This will give you a chance to review the changes.
Once you're happy with the changes, merge the PR.

## Raise a PR

Raising a PR will automatically build the app, push the docker image, and deploy it to
environments for functional and non-functional testing.

## Merge the PR

Merges to main by default do the same as a PR, and additionally deploy to a stable dev namespace that
can be used for showcasing or integration testing.

Next [learn more about how to implement the P2P](../../p2p)

### Manually raising a PR

If you don't want to use `corectl` you can raise PRs against your environments repo.

- Create a new repository or pick an existing one
- Render the template using `corectl template render <template-name> <path>`
- Adjust the rendered template to your needs and push the changes
  - Rendered templates has `.github/workflows` in the root.
    If you rendered the template not in the root of the repository,
    you might need to move workflow files in `.github/workflow` in the root of the repository.
    Unless you have autodiscovery implemented for your workflows,
    similar to what is done in [core-platform-reference-applications](https://github.com/coreeng/core-platform-reference-applications).
    In this case you can simply delete `.github/workflows` from the rendered template.
- Configure P2P for the repository using `corectl p2p env sync <repository-path> <tenant-name>`
- Make sure that the repository is present in the `tenants` list in the tenant file,
  for example:
```yaml
...
cost-centre: tenants
environments:
  - gcp-dev
repos: [https://github.com/<your-github-id>/<your-new-repository>]
...
```
