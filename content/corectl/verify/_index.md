+++
chapter = false
title = "Validate Core Platform CLI"
weight = 300
+++

## Verify `corectl` Installation and Initialization

Once you've done that you can list and connect to environments. The Core Platform is a fully private cluster so
`corectl` is used to create a temporary, private, tunnel to the cluster in each enviornment.

```bash
corectl env list
 NAME         ID                      CLOUD PLATFORM
 gcp-dev      core-platform-efb3c84c  GCP
 gcp-pre-dev  core-platform-26f47174  GCP
 gcp-prod     core-platform-e0d5e766  GCP
```
```bash
gcloud auth 
gcloud auth application-default login
```
```bash
corectl  env  connect
    Select environment to connect to:

  1. gcp-dev
  2. gcp-pre-dev
  3. gcp-prod
```