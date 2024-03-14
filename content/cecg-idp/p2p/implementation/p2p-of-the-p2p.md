+++
title = "Path to prod of the path-to-prod"
weight = 2
chapter = false
pre = ""
+++

To help applications and tenants deploying applications to production we're create a [p2p tool](https://github.com/coreeng/p2p) that uses GitHub actions.

## How do we test this?

P2P has a basic CI that calls multiple variations of the workflows it's implementing. Any new workflow should be added to the ci workflow. However, this is not enough. Since this is standalone project, it has no platform to actually connect to, so all connecitivity parts are run with a `dry-run` flag that skips some of the steps. So how do we actually test this.

CI checks will validate if the branch if OK to be merged. Once merged it will create a new V0 version on the P2P. After that it will send a remote trigger to our [p2p-testing repo](https://github.com/coreeng/p2p-testing). This will execute the fastfeedback pipeline with the `V0` version. This version is overriden everytime a branch is merge to master and no minor or patch versions are created.

Once `p2p-testing` fastfeedback runs, it will send a remote dispatch with the result of the run to the [p2p](https://github.com/coreeng/p2p) repository. This will happen on both success and fail scenario. 
On the fail scenario it will give us visibility that the `p2p-testing` run failed, as that is a private repository for CECG and not everyone will have access to it, since `p2p` is open source.
On the success scenario it will create a new version to be used by all applications. It will create major, minor and patch tag, for example, for version `1.6.2` it will create the tags `v1`, `v1.6` and `v1.6.2`.
