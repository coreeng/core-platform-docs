+++
title = "Quality Gate: Local"
weight = 1
chapter = false
pre = ""
+++

The first quality date is verification that can be done locally on the build agent or workstation. For example:

* Unit tests
* Static verification

Put all of this into the `p2p-build` task.

The output from `p2p-build ` is typically an immutable, versioned artifact.