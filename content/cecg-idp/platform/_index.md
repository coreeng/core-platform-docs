+++
title = "Platform Operations"
weight = 1
chapter = false
pre = ""
+++


### Platform Readonly Group

The platform readonly group is used to specify which users in your organisation are authorised to generate a kubeconfig allowing them to execute kubectl commands against the cluster. This group does not authorise members to modify any resources in the cluster, as the name implies.
This group name is configurable, but we recommend something like platform-readonly@cecg.io and doesn’t need any further configuration. This group can contain users, groups and service accounts.

