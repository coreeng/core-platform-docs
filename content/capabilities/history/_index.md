+++
title = "Core Platform History"
weight = 7
chapter = false
pre = ""
+++

The Core Platform is a full developer platform, usable out of the box, on GCP (see [roadmap](../roadmap/) for other cloud support) based on the lessons learned from CECG's consulting arm building large scale developer platforms at big enterprises.

The big project miletones were:
* **Inception**: initial agreement with initial beta customer to adopt the platform as we build it
* **Dev Onboarding**: unblocking developers with environments and pipeliens
* **Full Onbaording**: guarantee that environments will be long-lived and not rebuilt
* **Production Ready**: ready for production worklods, CECG migrates its first production app onto its instance
* **Devex**: after production ready, focus on onboarding experience and operations with a new CLI

![timeline.png](timeline.png)

### 2023 Q3

The product was kicked off in August 2023. With the following milestones set based on:
* Unblocking app developers as soon as possible < 2 weeks
* Unblock app develoeprs doing a full path to production < 3 months
* Prove out the operations model of a user platform operator deploying new versions
* Final set of long-lived environments in < 3 months
* Production ready in < 6 months

This was an aggressive set of milestones but achieveable given the engineers working on the Core Platform have built 
developer platforms many times.

#### Dev Playground (Week 2)

* GCP environment up and running (light weight GCP landing zones)
* Each dev can have its own tenancy (namespace) to develop their own application
* Deploy and run apps in K8s cluster
* Reference applications including basic CI/CD

#### Dev Environment Not-Live (Month 1)

* Ability to access deployed services through a URL
* Resource utilisation and platform health monitoring

#### All Environments Not-Live (PreDev, Dev, Prod) (Month 3)

* DevOps engineer will be able to deploy platform upgrades and test changes before releasing them to developers and into production
* Platform metrics such as uptime and latency, exposed via dashboards and alerts
* Detect platform configuration issues
* Tenants will be able to view logs and custom metrics for their deployed applications

By the end of the quarter the following milestones were met:
* Dev Playground (Week 2) 
* Dev Environment Not-Live (Month 1) 

#### All Environments Live (PreDev, Dev, Prod) (Month 6)

### 2023 Q4

The following milestones were met on time:
* All Environments Not-Live (PreDev, Dev, Prod), including but not limited to:
  * [Cloud Access](/app/accessing-cloud-infra/) - the ability for workloads to access cloud workloads outside of the   platform securely without passwrods
  * Slack integration for alerts
  * Consolidated Alerting Dashboard
  * Ingress - expose services over TLS


### 2024 Q1 

The following milestones were met on time:
* All Environments Live (PreDev, Dev, Prod)
* CECG's first production workload running on its instance of the platform

The Core Platform is now ready for production.

### 2024 Q2

* A big focus on improving developer experience and introducing the Platform CLI CoreCtl
* Autoscaling!
* Tenant monitoring stack
* Tenant support for using k6 for load testing

### 2024 Q3

* Multi tenent access to secrets in GCP Secret Manager 
* Static NAT IPs
* 
