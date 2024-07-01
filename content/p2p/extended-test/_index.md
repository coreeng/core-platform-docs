+++
title = "Quality Gate: Extended Test"
weight = 3
chapter = false
pre = ""
+++


Extended NFT can mean multiple things and there are a variety of issues it can assert.
These are typically based on Non-Functional-Requirements(NFRs) which should state what’s the average load expected, peak traffic(both requests per second and concurrent users) and response times in the different percentiles.
To simulate processing, it can be expected for a stub with a delay used to simulate processing time of a downstream application.

## Types of test
### Peak Load Test
Taken from the peak traffic. These tests typically run for ~1h and ensure the peak traffic can run within the expected response times. 

### Soak Test
Tests based on the average throughput from the NFRs. These tests typically run longer than peak, running from 4 h duration to a 24/7 environment. They are good to evaluate the stability of the system, catching any degradation of the system like memory leaks.

### Rolling Update
This test ensures that a new deployment is successful and doesn’t cause errors even when the pods of the ingress controller restart. For that it should ensure that it:
* Stops accepting new connections.
* Processes the inbound connection that it has already accepted.
* Exits after everything is processed with exit code 0. 

### Resilience Tests
This type of test, like the name says, is used to test the resilience of the system. Taking the same example of the Ingress feature, we can use this to remove all the pods in a certain availability zone and ensure that even though it’s receiving traffic, no error occurred.


## How to use this on the pipeline?
These should be triggered by a cron on git actions, and the pipeline will look like:
{{< figure src="/images/p2p/extended-tests.png" title="Extended-tests" >}}

## Usage
```
name: Extended Test

on:
  workflow_dispatch:
  schedule:
    - cron: '30 22 * * *'

permissions:
  contents: read
  id-token: write

jobs:
  get-latest-version:
    uses: coreeng/p2p/.github/workflows/p2p-get-latest-image-extended-test.yaml@v1
    with:
      image-name: knowledge-platform

  extendedtests:
    needs: [get-latest-version]
    uses: coreeng/p2p/.github/workflows/p2p-workflow-extended-test.yaml@v1
    with:
      version: ${{ needs.get-latest-version.outputs.version }}
```

This task will get the latest version that's on the `/extended-test` registry and execute the extended tests. If these are successful, it will promote the image to `prod`.

## Setup
See the [GitHub Variables](..)

