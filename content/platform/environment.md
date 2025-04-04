+++
title = "Platform Environments"
weight = 2
chapter = false
pre = ""
+++

The Environment in core platform represents the deployment and testing context for a tenant. Each tenant must be associated with an environment where applications can be tested and deployed, allowing teams to manage and isolate different environments efficiently.

Each environment has a set of predefined workflows that will be executed to test, validate, and publish the application. These workflows ensure the stability and reliability of deployments across different stages

## Choosing an Environment

When setting up a new tenant, you will be prompted to choose an environment eg:

- **Development (`dev`)** should be used for frequent testing and experimentation.
- **Production (`prod`)** should only be used for live applications with end-user interactions.
