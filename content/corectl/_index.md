+++
chapter = false
Title = "Core Platform CLI"
weight = 4
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

To start working with `corectl` you must install and initialize it:


#### 1. [Install Core Platform CLI](./install)



#### 2. [Initialize Core Platform CLI](./init)
