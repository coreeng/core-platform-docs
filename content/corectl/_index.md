+++
title = "Core Platform CLI"
weight = 20
chapter = false
pre = ""
+++

## Core Platform CLI: corectl

`corectl` is a CLI tool to automate common operations with Core Platform:

- creation of new tenancy
- creation of new application from template
- connect to environment
- others

`corectl` does its job by:

- manipulating the Core Platform configuration files.
  Since the Core Platform configuration files are stored in a git repository, `corectl` will clone
  some repositories and make changes to the configuration files on your behalf.
- calling GitHub APIs.
  Some operations may require GitHub API calls to perform their job.
  Example: to make P2P work,
  the user has to configure specific GitHub variables and environments for an application repository.
  `corectl` can configure it automatically.
- executing other commands locally.
  Some operations may require running other CLI tools to perform an operation.
  Example: connection to an environment.
  It requires cloud-specific CLI to be installed.
  `corectl` will use it and the Core Platform configuration to construct and run the correct command.

To start working with `corectl`:

1. Install its binary
2. Initialize `corectl`

## Install `corectl` binary

### From release

You can find release versions of `corectl` [here](https://github.com/coreeng/corectl/releases).

```bash
VERSION='0.18.0'
# Darwin is for MacOS, Linux is for Linux
# Note: Windows is not supported
OS='Darwin' 
# If OS==Darwin, ARCH=arm64 is for Apple Silicon, otherwise it's x86_64
ARCH='arm64' # or x86_64
# Download release
curl -L https://github.com/coreeng/corectl/releases/download/v${VERSION}/corectl_${OS}_${ARCH}.tar.gz > corectl.tar.gz

# Extract binary
tar -xzvf corectl.tar.gz corectl

# Make binary accessible in $PATH
sudo mv ./corectl /usr/local/bin/corectl
```

### From source

To install `corectl` from source, you need to have [Go](https://go.dev/learn/) installed.

```bash
git clone https://github.com/coreeng/corectl.git
cd corectl
make install
```

## Initialize `corectl`

Before usage, you should initialize `corectl`.
It requires the following:

- initialization file: `corectl.yaml`

  ```yaml
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

## GitHub Access Token

You can provide one of the following types of GitHub Access tokens:

- [Classic Personal Access Token](#classic-personal-access-token)
- [Fine-Grained Token](#fine-grained-tokens)

### Classic Personal Access Token

Scopes required:

- `repo`, since `corectl` needs access to read, create repositories, create PullRequests, configure environments and variables for the repositories.
- `workflow`, since `corectl` may create workflow files when creating new applications.

### Fine-grained tokens
>
> **_NOTE_**: Your organization has to enable use of fine-grained tokens for this to be possible.

Requirements for token:

- It should have access to all your organization repositories, since `corectl` might be used to create and configure new repositories.
- Read-Write permissions for Administrations, since `corectl` might be used to create new repositories for applications.
- Read-Write permissions for Contents, since `corectl` will try to clone repositories with configuration and might be used to update contents of the repository.
- Read-Only permissions for Metadata, since `corectl` uses GitHub API with metadata to perform some logic (check if repository exists, for example).
- Read-Write permissions for Workflows, since `corectl` might configure workflow files when creating new applications.
- Read-Write permissions for Environments and Variables, since `corectl` might be used to configure P2P for repositories.
- Read-Write permissions for Pull Requests, since `corectl` might be used to automatically generate Pull Requests with platform configuration updates.
