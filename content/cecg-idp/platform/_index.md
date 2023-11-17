+++
title = "Platform Operations"
weight = 1
chapter = false
pre = ""
+++

Deploying the CECG Developer Platform is:

* Create your Platform Readonly Group
* Create your GKE Security Group


## Platform Readonly Group

The platform readonly group is used to specify which users in your organisation are authorised to generate a kubeconfig allowing them to execute kubectl commands against the cluster. This group does not authorise members to modify any resources in the cluster, as the name implies.

The group should be: platform-readonly@domain e.g. `platform-readonly@cecg.io` if your domain is `cecg.io`

## GKE Security Group

We leverage GKE’s native support for using Google Groups to support RBAC within Core Platform clusters. A requirement of this native support is a Google Group named gke-security-groups@domain to act as a top level container for nested team based groups.

This group should only contain other google groups as members, not users or service accounts (the user who creates the group will be an owner, this is fine).


## Group Member Visibility

The GKE + Google Groups native integration requires an additional configuration change to the gke-security-groups group, documented here. In summary, for the new group, you need to go into the Group Settings -> General page and set Who can view members to be Group Members (or organisation wide)