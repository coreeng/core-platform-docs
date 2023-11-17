+++
title = "Platform Troubleshooting"
weight = 10
chapter = false
pre = ""
+++


## Deployment Failures

#### Local port [xxxx] is not available

A local port is used locally on the GitHub agent to IAP proxy to the Kubernetes API server. 
Sometimes a randomly selected port is not available.

#### Logs

```
2023-11-17T16:31:21.6142491Z --- Start tunnel (IAP)
2023-11-17T16:31:28.1159411Z ERROR: (gcloud.compute.start-iap-tunnel) Local port [57834] is not available.
```

#### Actions

The job can be re-run using re-run failed jobs
