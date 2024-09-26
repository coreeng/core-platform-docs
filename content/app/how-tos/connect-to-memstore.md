+++
title = "Connect to MemoryStore"
weight = 4
chapter = false
pre = ""
+++

## Connectivity

Creating and accessing a Database like Redis with PSA is simpler that cloudsql.
After you configure your tenancy network,
you'll be able to create your redis instance.
There, you'll chose `PRIVATE_SERVICE_ACCESS`
as the connection mode and configure the Core Platform's network as the authorized network
which is constructed like

```shell
  projects/${platform_project_id}/global/networks/${platform_environment}-network"
```

Once configured and deployed, the redis instance will be given a private IP from the PSA range and you'll be able to reach it without any more configurations from your pods.

## Auth

Being part of the same network, this will not be using IAM SA Auth, nor is it support. Auth is disabled by default and can be enabled. Read more about [Redis Auth here](https://cloud.google.com/memorystore/docs/redis/about-redis-auth)

## Disadvantages

Being on the same network as the platform, means that any pod inside that network will have connectivity to redis, whether it's the same tenant or not.
The way to prevent this will be to have Network Policies with default deny to the PSA range and only enabling it for a specific tenant.
