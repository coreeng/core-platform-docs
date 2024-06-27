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

- Create a new repository
- Render the template using `corectl template render <template-name> <repository-path>`
- Adjust the rendered template to your needs and push the changes
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

### Forking [core-platform-reference-applications](https://github.com/coreeng/core-platform-reference-applications) repo
This repo contains rendered software templates with configured P2P.
It's possible to fork it and quickly configure it for your own environment.
Read more details in README.md.

After the fork, you can use delete unnecessary files and folders, and start extending one or more existing applications.

The structure of the repository implies that it contains separate related applications with distinct P2P lifecycles. 

To add P2P lifecycle, you should create a new folder with Makefile with P2P tasks.

## Raise a PR

Raising a PR will automatically build the app, push the docker image, and deploy it to
environments for functional and non-functional testing.

{{% notice note %}}
If you have forked the core-platform-reference-applications repo, then:

* You need to manually enable the workflows in your forked repository. To do this, navigate to your repository on GitHub. Click on the 'Actions' tab. If you see a notice about workflow permissions, click on 'I understand my workflows, go ahead and enable them'.

* In the Makefile of your repository, change the `tenant_name` variable to match the name of the tenancy you created."
{{% /notice %}}



## Merge the PR

Merges to main by default do the same as a PR, and additionally deploy to a stable dev namespace that
can be used for showcasing and integration testing.

Next [learn more about how to implement the P2P](../../p2p)
