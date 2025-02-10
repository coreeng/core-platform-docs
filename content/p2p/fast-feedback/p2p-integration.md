+++
title = "Integration Test"
weight = 4
chapter = false
pre = ""
+++
Make target: `p2p-integration`

Integration is the first time your application is integrated with other applications.
Different levels of integration will be appropriate depending on your architecture.

### Deploy Application

Deploy to the following namespace

`<app_name>-integration`

Or if you have multiple apps in the same tenancy

`<tenant>-<app-name>-integration`

### Run Tests

Execute integrated functional tests, we recommend using a BDD framework. All software templates come with example tests.
