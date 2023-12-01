+++
title = "Developer Platform"
weight = 1
chapter = false
pre = ""
+++

The {{< param company >}} Developer Platform is an implementation of a [Core Platform](/core-platform).

## Accessing the Cluster 


The Developer Platform is an entirely private cluster. The Kubernetes endpoint is not exposed to the Internet. 

Before accessing a cluster, ensure you have the following installed:

1. gcloud 
2. kubectl
3. gke-cloud-auth-plugin

Go to your [Environments Repo]({{< param environmentRepo >}}) for the commands and configuration for accessing the cluster. 

The environments supported in this deployment are:

{{< environments >}}

## Operating the Platform

For how to operate the platform head to [Platform Operations](./platform)

## Deploying applications to the Platform

For how to deploy applications the platform head to [Deploying Applications](./app)
