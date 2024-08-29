+++
title = "Integration Test"
weight = 3
chapter = false
pre = ""
+++

Integration Testing verifies that the individual parts of the system communicate correctly with each other, those parts might include Databases, Message Queues, Lambda functions, etc.
The wider aspect of Integration Testing includes service-to-service communication, when API’s connect to middle tier services etc.
Another point of consideration for integration testing is when features come together in main and how different features interact with each other.
Integration testing is essential to the SDLC, it provides a consistent approach in validating the stability of the whole environment, as well as the integration points between services.
We expect these tests to run against a deployed application.

### Main characteristics:

- Fast Integration off main branch
- HA Environment Treated Like Prod
- Non-Disruptive Deployments / Graceful Termination
- Monitoring and Alerting Setup Early
- Tests Own Test Data Lifecycle
- Anyone Can Start A Test At Anytime
- Additional Centralized Test Suites Run
- Second Hardest Environment To Get Right
- Tests should cover the different features and routes, both happy cases and fail cases
