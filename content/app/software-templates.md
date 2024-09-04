+++
title = "Software Templates"
weight = 19
chapter = false
pre = ""
+++

## What is a software template?
Software template provide pre-built, standardized structures for common types of applications. This allows 
developers to:

- Quickly start new projects without building the basic architecture from scratch
- Ensure consistency across multiple projects
- Follow best practices and proven patterns built into the template
- Focus on implementing specific business logic rather than generic boilerplate code

This efficiency can significantly reduce development time, especially for common application types, allowing teams 
to deliver projects faster and with more consistency.
                                          
## CECG Software Templates

CECG provides software templates that integrate the entire P2P lifecycle, 
offering a significant advantage in application development. 

These templates:
- Incorporate the full P2P process out-of-the-box
- Include built-in deployment pipelines with gated stages
- Enable developers to start from zero and rapidly create a functional application
                
You can find the templates in the [CECG Software Templates repository](https://github.com/coreeng/core-platform-software-templates)


## Integration via corectl

Corectl leverages the templates to create a new project via `corectl app create` command.

To ease authoring of a new software template there is a command `corectl template render` that will render a 
template into a new directory.


## Parameters

Software templates can be parameterized to allow for customization of the template.

There are 2 types of parameters:

1. Custom parameters defined in the `template.yaml` file
2. Implicit parameters set by corectl when creating a new application

### Custom parameters
Custom parameters are defined in the `template.yaml` file.

They are defined in the `parameters` section of the file.

For example:
```yaml
parameters:
  - name: appName
    description: Name of the application
    type: string
    optional: true
    default: my-app
```

When rendering a template corectl will prompt user for the values of the parameters.


### Implicit parameters
Implicit parameters are set by corectl when creating a new application.

At the moment, there are 4 implicit parameters:

```yaml
- name: name
  description: application name
  optional: false

- name: tenant
  description: tenant used to deploy the application
  optional: false

- name: working_directory
  description: working directory where application is located
  optional: false
  default: "./"

- name: version_prefix
  description: version prefix for application
  optional: false
  default: "v"
```

- `name` is the name of the application
- `tenant` is the tenant used to deploy the application

