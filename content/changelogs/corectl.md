+++
title = "Corectl"
weight = 3
chapter = false
pre = ""
+++

# What is it?

This is a CLI tool for CECG's [Core Platform](https://www.cecg.io/core-platform/)!
From connecting to cluster, creating templated applications and a lot more!

## v0.31.3

### What's Changed

* Update to match core-platform 0.31.3 by @kkonstan

## v0.31.2

### What's Changed

* Update to match core-platform 0.31.2 by @kkonstan

## v0.31.1

### What's Changed

* Update to match core-platform 0.31.1 by @kkonstan

## v0.31.0

### What's Changed

* Update to match core-platform 0.31.0 by @kkonstan

## v0.30.6

### What's Changed

* Update to match core-platform 0.30.11 by @kkonstan

## v0.30.5

### What's Changed

* Update for core-platform 0.30.10 by @kkonstan

## v0.30.4

### What's Changed

* Update go dependencies by @kkonstan
* Integration tests cleanup by @kkonstan
* Update dependencies by @kkonstan
* Show changelogs for multiple outstanding releases by @tim-codes
* Fall back silently when no environments.yaml exists to avoid confusion by @kkonstan
* Initial routine changes to use config/GetCorectl... functions by @withnale

## v0.30.3

### What's Changed

* Update Go dependencies by @kkonstan

## v0.30.2

### What's Changed

* Update core-platform to 0.30.2 by @kkonstan

## v0.30.1

### What's Changed

* Update go dependencies by @kkonstan
* bump core-platform 0.30.1 by @tim-codes

## v0.30.0

### What's Changed

* Switch from iap tunnel to dns endpoint by @kkonstan
* Update go deps by @kkonstan
* Error handling when exporting root p2p env vars by @tmcalves

## v0.29.3

### What's Changed

* Improve env connect logging output and reduce verbosity by @kkonstan

## v0.29.2

* Update dependencies by @kkonstan
* Fix proxy and update command with logger instead of wizard by @tmcalves
* go fmt by @kkonstan

### What's Changed

## v0.29.1

* Log output to file that is sent to stream output by @tmcalves

### What's Changed

## v0.29.0

### What's Changed

* Update dependencies by @kkonstan

## v0.28.0

### What's Changed

* Remove cost centre tenant attribute by @kkonstan
* Switch logger. Add ADR by @tmcalves

## v0.27.2

### What's Changed

* Better error msg if gitconfig is missing by @fabricetriboix
* Update dependencies by @kkonstan
* Automatically update config repos by @fabricetriboix
* Simplify confirmation dialogue by @fabricetriboix
* Fix env selection for tenant create by @fabricetriboix
* Show a tenants tree by @fabricetriboix
* Update README file by @fabricetriboix

## v0.27.1

### What's Changed

* 522-confirm-app-monorepo: Improve user experience when creating app in monorepo by @fabricetriboix
* 519-corectl-simple-init: Use config init from environments repo by default by @fabricetriboix
* Use ubuntu-24.04 instead of ubuntu-latest by @kkonstan
* Update dependencies by @kkonstan

## v0.27.0

### What's Changed

* Rebrand developer-platfrom -> core-platform by @kkonstan

## v0.26.3

### What's Changed

* Remove duplicate definitions on app commands. by @withnale
* Disable showing usage once processing begins by @withnale
* 427-env-select: Improve environment selection by @fabricetriboix
* 475-monorepo-msg: Fix message shown to the user when creating an appa monorepo by @fabricetriboix
* Added initial implementation of background env connect by @withnale

## v0.26.2

### What's Changed

* Reducing logging level for IAP tunnels.

## v0.26.1

### What's Changed

* Bump to latest platform.
* Makefile in style of developer platform.
* Fix linting, so CI fails.

## v0.26.0

### What's Changed

* Swap out connect implementation to use IAPC.

## v0.25.5

### What's Changed

* Use git shell for pull + push operations.

## v0.25.4

### What's Changed

* Use Tag instead of Version as version label.
* Validate tenant creation with respect to all other tenants.

## v0.25.3

### What's Changed

* In case coloring was disabled, the internal value was not updated. Fix the condition.
* Trigger workflow in monorepo only for changed apps.
* Display skipped task message in case repository is already present in tenant definition.
* Add update command

## v0.25.2

### What's Changed

* Add --dry-run support to `app create` and `tenant create`,  add logging to git, github, and filesystem operations. Add Wizard component. Rework bubbletea component hierarchy by @Malet

## v0.25.1

### What's Changed

* bug(app-create): Fix issue when creating an app in monorepo is not possible, because it couldn't create relative path from absolute and relative path. by @Mugenor

## v0.25.0

### What's Changed

* App create catch error by @nzacharia
* feat(cmd): add release version command by @Malet
* chore(deps): update developer-platform dependency by @Malet
* bug(git): Sometimes you can get git `fast-forward` error on push for the branches you are not working with at the moment. Fix it by pushing only the branch we are working with by @Mugenor
* fix(releases): update goreleaser action by @Malet

## v0.24.1

### What's Changed

* fix: correctly allow creation of monorepo app by @lukasz-kaniowski

## v0.24.0

### What's Changed

* feature: convenience commands by @Mugenor

## v0.23.1

### What's Changed

* feature(template-parameters): Support custom template parameters by @Mugenor
* Set working_directory and version_prefix arguments for monorepo flow by @lukasz-kaniowski

## v0.23.0

### What's Changed

* 395: improve error messages on init command by @tombart
* updated developer-platform lib to latest by @tombart
* export env variables required to run onboarded apps p2p makefile targets by @tombart
* App create command in monorepo setup by @lukasz-kaniowski
* Allow render uncomited changes from templates by @lukasz-kaniowski
* Pass params file to a template render command by @lukasz-kaniowski
* Make app create `--from-template` flag optional by @lukasz-kaniowski
* bug(tenant-create): handle parent root tenant properly by @Mugenor

## v0.20.0

### What's Changed

* Make env connect env argument optional by @chbatey
* p2p promote command by @lukasz-kaniowski

## v0.18.1

### What's Changed

* bug(tenant-create): multiselect pickers were not shown by @Mugenor
* feature(cfg): Remove tenant from config by @Mugenor
* feature(connect): Small fixes to env-connect by @Mugenor

## v0.18.0

### What's Changed

* LICENCE and README by @chbatey
* feat(env): add list command by @SennaSemakula
* feat(env): connect to environment command by @SennaSemakula
* feature: commands to access env resources by @Mugenor
* Upgrade core platform to 0.18 by @chbatey
* Remove duplicate app commands by @chbatey
* chore(docs): update readme reference importance of using real env and software templates repos by @SennaSemakula

## v0.11.1

### What's Changed

* Initial implementation by @Mugenor
* add INTERNAL_DOMAIN to envs by @SergeiSizov
* change to INTERNAL_SERVICES_DOMAIN after discussions by @SergeiSizov
* CI/CD by @Mugenor
* feat: add body text to created pull requests by @pyoio
* doc(versioning): ADR on v0 versioning by @Mugenor
* Feature/295 refactor by @petersjtaylor854
* refactor: extract core reusable logic to `developer-platform` by @Mugenor
