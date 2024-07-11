+++
title = "Core Platform"
weight = 1
chapter = false
+++

## Core Platform Documentation

Welcome to the [Core Platform](https://www.cecg.io/core-platform/) Documentation!

Core Platform is your ultimate all-in-one developer platform designed to turbocharge your software development journey from Day 1.

These docs assume you've already deployed a full set of Core Platform Environments. If you haven't 
please go to [Core Platform](https://www.cecg.io/core-platform/) to get in touch with us to set up
your environments.

## Getting started

Start by configuring the [Core Platform CLI](./corectl) and then follow the guides below.

Once you've done that you can list and connect to environments. The Core Platform is a fully private cluster so
`corectl` is used to create a temporary, private, tunnel to the cluster in each enviornment.

```
corectl env list
 NAME         ID                      CLOUD PLATFORM
 gcp-dev      core-platform-efb3c84c  GCP
 gcp-pre-dev  core-platform-26f47174  GCP
 gcp-prod     core-platform-e0d5e766  GCP
corectl  env  connect
    Select environment to connect to:

  1. gcp-dev
  2. gcp-pre-dev
  3. gcp-prod
```

Now you're setup with `corectl`:

- Want to deploy a new application? See [Deploying Applications](./app)
- Want a full reference for how to use implement Continuous Delivery? See [Path to Production](./p2p)
- Are you operationally responsible for the platform? See [Platform Operations](./platform)
