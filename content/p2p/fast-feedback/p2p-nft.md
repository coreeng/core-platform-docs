+++
title = "Deployed Stubbed NFT"
weight = 3
chapter = false
pre = ""
+++

Make target: `p2p-nft`

Shift left the non-functional verification of your application.

Stub out any external dependencies apart from databases / caches / queues to enable reliable, fast feedback, with
the ability to test failure scenarios.

### Deploy Application

Deploy to the following namespace

`<app_name>-nft`

Or if you have multiple apps in the same tenancy

`<tenant>-<app-name>-nft`

### Run Tests

Execute non-functional tests. We recommend using [k6] and software templates come with example non-functional tests.
