+++
title = "Infra Connector"
weight = 1
chapter = false
pre = ""
+++

## Infra Connector
Infra connector is a module in the reference core platform that allows to create cloud objects using kubernetes resources.

Current implementation for GCP uses the [k8s config connector](https://github.com/GoogleCloudPlatform/k8s-config-connector)
Installing these will make available a variety of CRD that will allows to create differente GCP resources without the need to write terraform code. For example:
```
apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMServiceAccount
metadata:
  name: {{include "account.fullname" .Values.tenant.name }}
  annotations:
    propagate.hnc.x-k8s.io/none: "true"
spec:
  displayName: GCP Service Account for tenant {{ .Values.tenant.name }}
```
This will create a GCP SA for each the tenant being provisioned

## Current usage
The goal of this modules is to decouple terraform from the platform modules. Having this allows us to create cloud resources with something like helm and doesn't tie us down to terraform. Meaning we can couple or decouple any other modules a lot easier.
This means that this is 1 of the 2 modules in the current implementation that uses terraform, everything else is installed with the help of a script. If they require cloud resources, they will create them using the infra connector CRDs.

## Future usage
Another advantage of using this is that we can allow tenants to create GCP resources like buckets, databases etc that they might need without needing to reaching out to the platform or to a DevOps team, making the more independent. What they can and can't create will be control with a mix of RBAC and policy controller - A Role that will specify which objects they can create, and the policy controller to ensure what they create is allowed and it won't impact any other tenant. 