+++
title = "Stubbed Functional Test"
weight = 1
chapter = false
pre = ""
+++

These tests are used to run end-to-end tests and validate that the software features works as desired.
We expect these tests to run against a deployed application.
Tests should cover the different features and routes, both happy cases and fail cases. To simulate fail scenarios such as an error from a downstream dependency, it's recommended to use mock services like [wiremock](https://wiremock.org/)
