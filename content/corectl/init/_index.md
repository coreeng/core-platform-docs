+++
chapter = false
title = "Initialize Core Platform CLI"
weight = 200
+++

## GitHub Access Token

Before initializing corectl, you need to create a GitHub access token to use during the initialization process

You can provide one of the following types of GitHub Access tokens:
- [Classic Personal Access Token](#classic-personal-access-token)
- [Fine-Grained Token](#fine-grained-tokens)


### Classic Personal Access Token

[How to Create Classic Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic)

Scopes required:
- `repo`, since `corectl` needs access to read, create repositories, create PullRequests, configure environments and variables for the repositories.
- `workflow`, since `corectl` may create workflow files when creating new applications.

### Fine-grained tokens
> **_NOTE_**: Your organization has to enable use of fine-grained tokens for this to be possible.

[How to Create Fine-grained token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token)

Requirements for token:
- It should have access to all your organization repositories, since `corectl` might be used to create and configure new repositories.
- Read-Write permissions for Administrations, since `corectl` might be used to create new repositories for applications.
- Read-Write permissions for Contents, since `corectl` will try to clone repositories with configuration and might be used to update contents of the repository.
- Read-Only permissions for Metadata, since `corectl` uses GitHub API with metadata to perform some logic (check if repository exists, for example).
- Read-Write permissions for Workflows, since `corectl` might configure workflow files when creating new applications.
- Read-Write permissions for Environments and Variables, since `corectl` might be used to configure P2P for repositories.
- Read-Write permissions for Pull Requests, since `corectl` might be used to automatically generate Pull Requests with platform configuration updates.



## Initialize `corectl`
Before usage, you should initialize `corectl`.
It requires the following:
- initialization file: `corectl.yaml`
  ```
  repositories:
    cplatform: <environments-git-repo> # [Mandatory] repository clone path with your environments configuration
    templates: <templates-git-repo> # [Mandatory] repository clone path with your software templates, optionally you can use our template repo: https://github.com/coreeng/core-platform-software-templates.git

  p2p: # path to production configuration
    fast-feedback: # [Mandatory] p2p stage
      default-envs: # list of environments to use as a part of the fast-feedback stage, must match env names defined in repositories.cplatform
      - <environment_name> 
    extended-test: # [Mandatory] list of environments to use as a part of the extended-test stage, , must match env names defined in repositories.cplatform
      default-envs:
      - <eenvironment_name>
    prod: # [Mandatory] list of environments to use as a part of the prod stage, , must match env names defined in repositories.cplatform
      default-envs:
      - <environment_name>
  ```
  This file should be located in the root of your environments repository.
  You can find an example of this file [here](https://github.com/coreeng/corectl/blob/main/examples/init-example.yaml).
- your personal GitHub token to perform operations on your behalf. See more info [here](#github-access-token)

To run initialization run:
```bash
corectl config init
```

It saves configuration options and clones some repositories:
- environments repository – the repository that holds the configuration settings and parameters for core platform
  environments.
- software-templates repository – the repository featuring bootstrap templates designed for quick project setups.
  You can either build your own library of templates or use/extended [the one provided by CECG](https://github.com/coreeng/core-platform-software-templates).


