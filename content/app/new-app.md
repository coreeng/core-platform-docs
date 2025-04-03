+++
title = "Create application"
weight = 3
chapter = false
pre = ""
+++

## Create a new application

The Core Platform with a single command will configure:

- A new repository
- A template application demonstrating full continuous delivery:
  - Versioning
  - Functional testing
  - Non-functional testing
  - Promotion between a set of standard environments
  - Deployment to production

After running this command, and triggering the resulting GitHub workflow you'll have an
application ready to deploy to production on every commit!

```shell
corectl apps create <new-app-name> [<new-app-dir>]
```

{{% notice warn %}}
`new-app-name` must be lower case, as Docker only allows lowercase letters for image names.
{{% /notice %}}

It will:

- prompt you a few additional questions, including template for the application.
- create a new repository using the selected template
- configure the created GitHub repository, so P2P workflows will run without an issue

## Developer workflow

Now you have an application deployed to production. You can make changes by raising PRs.

### Raise a PR

Raising a PR will automatically build the app, push the docker image, and deploy it to
environments for functional, non-functional, and integration testing.

### Merge the PR

Merges to main by default do the same as a PR, and additionally deploy to a stable dev namespace that
can be used for showcasing or integration testing.
