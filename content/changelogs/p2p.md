+++
title = "Path to Production"
weight = 2
chapter = false
pre = ""
+++

# What is it?

Path to production (P2P) is the github workflows tool we provide for tenants to deploy their applications and can be found [here.](https://github.com/coreeng/p2p)

To learn more about it, check our [P2P documentation.](../../p2p/)

## Notes

We always update the major and minor version on new releases. We recommend using `v1` to avoid having to update on each version, as we'll ensure no breaking changes are introduced. You can also use the minor version to be slightly more strict as that one will also be overridden with the new version on each release, like `v1.1`.

# Changelog

## v1.6.83

### What's Changed

* Use correct region for docker login by @kkonstan

## v1.6.82

### What's Changed

* Add env_vars support to platform workflows by @kkonstan

## v1.6.81

### What's Changed

* Pass GITHUB_TOKEN to commands ran by platform-release.yaml by @kkonstan

## v1.6.80

### What's Changed

* Pass GITHUB_TOKEN to commands ran by platform-execute-command.yaml by @kkonstan

## v1.6.79

### What's Changed

* bug: Fix p2p-image task by @Mugenor

## v1.6.78

### What's Changed

* Drop tenant from app suffix url by @kkonstan

## v1.6.77

### What's Changed

* P2P_VERSION should default to something that's semver by @kkonstan

## v1.6.76

### What's Changed

* Ensure GITHUB_TOKEN is set when executing p2p make targets by @kkonstan

## v1.6.75

### What's Changed

* Add back p2p-image and new p2p-images to print primary and all image names by @kkonstan

## v1.6.74

### What's Changed

* Explicitly disable cancel in progress for execute-command workflows by @kkonstan

## v1.6.73

### What's Changed

* Move all p2p targets except promotion back to app repos by @kkonstan

## v1.6.72

### What's Changed

* Fix typos in readme by @erikzele

## v1.6.71

### What's Changed

* Adds P2P V2 functionality in a backwards compatible way, for testing by @kkonstan

## v1.6.68

### What's Changed

* Get latest image based on semver not timestamp by @kkonstan

## v1.6.67

### What's Changed

* Switch from container to artifact registry commands by @kkonstan

## v1.6.66

### What's Changed

* Add Google Cloud SDK step back, but with skip_install by @kkonstan

## v1.6.65

### What's Changed

* Switch gke eaccess from internal ip to dns based endpoint by @kkonstan

## v1.6.64

### What's Changed

* Remove version prefix from the p2pversion output by @tmcalves

## v1.6.63

### What's Changed

* Add version output to get latest version by @tmcalves

## v1.6.62

### What's Changed

* Add step with version on name by @tmcalves

## v1.6.61

### What's Changed

* Login to tenant registry by @tmcalves

## v1.6.60

### What's Changed

* Use separate step for tunnel using iapc by @kkonstan

## v1.6.59

### What's Changed

* Remove Google SDK step by @kkonstan

## v1.6.58

### What's Changed

* Use new artifact targets for tenant plan/apply by @kkonstan

## v1.6.57

### What's Changed

* Remove NumPy and Google SDK beta, only used for legacy IAP tunnel by @kkonstan

## v1.6.56

### What's Changed

* Run nft and integration at the same time as functional by @chbatey

## v1.6.55

### What's Changed

* Rebrand developer-platfrom -> core-platform by @kkonstan

## v1.6.54

### What's Changed

* Rebrand from Developer Platform to Core Platform by @kkonstan

## v1.6.53

### What's Changed

* Switch app workflows from ubuntu-latest to ubuntu-24.04 by @kkonstan

## v1.6.52

### What's Changed

* Switch platform workflows from ubuntu-latest to ubuntu-24.04 by @kkonstan

## v1.6.51

### What's Changed

* fix(logging): update iapc, reduce iapc log level to WARN by @Malet

## v1.6.50

### What's Changed

* chore(iapc): Use original iapc repo instead of our fork, since we got our fix merged by @Mugenor

## v1.6.49

### What's Changed

* features(iap): PoC – migrate to iapc tool since default gcloud iap tunnel is unstable by @Mugenor

## v1.6.48

### What's Changed

* Tweak Platform matrix pattern by @tmcalves

## v1.6.47

### What's Changed

* Migrate to PLATORM_ENVIRONMENT by @chbatey

## v1.6.46

### What's Changed

* added integration test step to fastfeedback workflow by @tombart

### Behaviour changes

New step `p2p-integration` has been added, this aims to run integration tests during the fast-feedback pipeline. Read more on [the documentation.](./../p2p/fast-feedback/p2p-integration.md)
As explained in the [fast feedback section](../p2p/fast-feedback/), this right now is an optional field but will become mandatory in the future.

## v1.6.45

### What's Changed

* Updating actions versions by @tmcalves
* add auth-azure step for vendor azure to platform-execute-command by @kkonstan
* import platform-release.yaml from developer-platform's release.yaml by @kkonstan
* Pin azure-auth to 1.5.1 by @kkonstan
* Promote image when the trigger is a tag by @tmcalves
* Typo fix by @tmcalves
* set ARM_* variables to get terraform azure provider to use OIDC by @kkonstan
* upgrade buildkit-cache-dance action to v3 by @kkonstan
* Add logic to not create a new tag if it already exists by @tmcalves
* Fix missing space by @tmcalves
* Delete p2penvtool directory by @chbatey
* Fix last commit hash calculation by @tmcalves
* Platform P2P pre/post targets by @kkonstan
* Add checkout-ref param to p2p-version by @Mugenor
* Add environments validate to CI and CD workflows by @SennaSemakula
* Install corectl in promote image job by @lukasz-kaniowski

## v1.6.30

### What's Changed

 Update README.md by @tmcalves

* Fix version increment to use patch instead of minor by @tmcalves
* Fix: Inject Secrets in P2P Promote Image by @luismy
* Update actions due to node16 deprecation by @kkonstan
* Fix bug where application prefix had to be single char by @tmcalves
* Test default version-prefix by @tmcalves
* propagate INTERNAL_SERVICES_DOMAIN env by @SergeiSizov
* Remove condition on tenant validations by @tmcalves
* Fixes bug where github_head_ref doesn't have a value. by @tmcalves

## v1.6.20

### What's Changed

* Run tenants-apply if environments haven't been udpated by @chbatey
* Add auth-aws step by @kkonstan
* V1 - fastfeedback of new P2P by @withnale
* duplication by @AndrewTtofi
* Adjust platform-execute-command to allow per-ref/env concurrency by @kkonstan
* Add step to get the latest version from gcp artifact registry by @tmcalves
* Isolate get latest image workflow on its own by @tmcalves
* Add tenant_name to registry by @tmcalves
* Do git checkout of tag when running extended tests and prod by @tmcalves
* Add kube auth to promotions by @tmcalves
* Changes and triggering the p2p build on CD by @tmcalves
* Fix failure pipeline by @tmcalves
