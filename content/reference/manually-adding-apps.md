+++
title = "Manually adding apps"
weight = 2
chapter = false
pre = ""
+++

## Manually raising a PR

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
- Make sure that the repository is present in the `tenants` list in the tenant file, for example:

```yaml
...
environments:
  - gcp-dev
repos: [https://github.com/<your-github-id>/<your-new-repository>]
...
```
