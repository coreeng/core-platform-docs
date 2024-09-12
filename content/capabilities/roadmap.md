+++
title = "Core Platform Roadmap"
weight = 5
chapter = false
pre = ""
+++

This is the roadmap for features to be developed over the next quarter. It is always subject to change
based on the requirements of the current beta customers.

## 2024 Q4

### Developer Portal

* Onboard and discover capabilities
* Discover all applications from a single place

### Default Deny

* All traffic within an organisation denied by default, with self-service API for opening up firewalls between applications.
* __OLD OVERVIEW MENTIONS EXPOSING PRIVATE ENDPOINTS AND INTERNAL FIREWALLS - are they related to this?__ 

### Policy: Encode your standards into the platform

* Industry best practices encoded into the platform e.g. Docker best standards
* Ability for you to encode your own custom standards e.g. No services exposed over HTTP
* __OVERVIEW IMPLIES POLICIES IS COMPLETE?__

### Transparent Encryption

* Full internal encryption for inter-service traffic (Ingress is already TLS)

## 2025

Larger ticket items that will be prioritised as users request them.

### Multi Cloud Support

Feature parity across AWS and Azure.

## Misc 

__ALL TO DISCUSS__

These were on the old version of the overview as future features but not mentioned here at all - probably should be in some way? 

### SQL DB

I assume this was SQL DB provisioning within the core platform (and currently we basically require such resources to be provisioned and managed outside the core platform)

### Redis 

(I assume this is basically the same deal as SQL DB)

### Cloud Account

I don't really know what this was? Is this like the ability to do more of the inception from scratch or even market space provisoning? 