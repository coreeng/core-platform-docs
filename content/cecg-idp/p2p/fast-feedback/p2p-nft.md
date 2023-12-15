+++
title = "Stubbed NFT"
weight = 1
chapter = false
pre = ""
+++

There are many types of non-functional tests but we typically call NFT's when we’re working with some sort of load testing.

## Fast Feedback NFTs
These tests should run peak load during a short period of time, typically no longer than 30m. They will ensure that the application hasn't degraded and that the non functional requirements are still being respected.

They can also test things like rolling updates, where the pods are restarted/redeployed to test a deployment under load and asserting there are no errors, as that's will be the case in production.
