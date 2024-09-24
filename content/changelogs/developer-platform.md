+++
title = "Developer Platform"
weight = 1
chapter = false
pre = ""
+++

# What is it?
This is the released artifact that is created to be deployed on each platform environment. You can change it by editing you `platform-environments/environments/<env_name>/config.yaml` and change your `release` value.

```yaml
release: "0.25.2"

environment: "gcp-dev"
...
```

## v0.25.2

### What's Changed
* fix(ingress): renamed misconfigured file in ingress module by @tombart
* docs(postmortem): added post-mortem md file to describe past issues/mitigations by @tombart
* Updating terraform providers by @tmcalves 
* bug(mtka): Revert migration to IAMPartialPolicy by @Mugenor

## v0.25.1 

{{% notice warning %}}
This version is unstable, do not use this version
{{% /notice %}}

### What's Changed
* add feature, remove feature, add extra files by @nzacharia
* bug(argocd): Fix argocd IAMPolicyMembers related errors by @Mugenor
* feature(argocd): Add alerts for argocd applications by @Mugenor
* bug(platform-secret-manager): Reference secret with projectNumericId instead of projectId. It caused the condition to be invalid by @Mugenor
* fix(iap): remove IAP backend errors after provisioning + alerts for no auth on internal services endpoint by @tombart

## v0.25.0
### What's Changed
* Slack failure notifications by @lukasz-kaniowski 
* feature(argocd): Expose argocd UI through internal ingress by @Mugenor 
* feature(developer-portal): upgrade backstage and plugins versions by @Mugenor

## v0.24.1
### What's Changed
* Fix priority class key for the CSI driver by @tmcalves
* NAT Gateway static ip allocation impl by @tombart
* Fix network test by @tmcalves
* Fix issues no caught in other sandboxes by @tmcalves
* add logging retention and k6-exclusion by @robertgmoss
* put logging into own module and fix provider config by @robertgmoss
* give roles/viewer to platform-readonly group by @robertgmoss
* configure portal database by @robertgmoss
* load internal_oci_registry_host from a variable by @SergeiSizov
* Update go deps by @kkonstan
* chore: fix docker env syntax deprecation warnings by @kkonstan
* Features/pkg support root tenant by @Mugenor

### Behaviour changes
* Added the possibility to configure log retention. By default this is now 30days. you can override it by adding this block to the configuration
```yaml
platformLogging:
  logRetentionDays: 10
```
* NAT Gateway static IPs feature has been enabled but it is disabled by default. To enable it, you'll need to configure your environment to have
```yaml
network:
  publicNatGateway:
    ipCount: 1
    logging: ERRORS_ONLY
    minPortsPerVm: 64
    maxPortsPerVm: 2048
```

For more details, please check the documentation

## v0.23.0
### What's Changed
* [developer-portal] Add backstage as feature by @coquinncecg
* adds terraform code to create cloudsql instance and updates chart with secret by @robertgmoss
* add PodMonitoring and alert configuration by @robertgmoss
* udpated links for runbooks for alerts by @tombart
* chore(secret-manager): Support syncing secrets to allow env vars by @SennaSemakula
* Move cert-manager from platform-ingress to cluster-hardening by @SergeiSizov
* always enable sqladmin api by @robertgmoss
* Remove duplicated SA creation by @tmcalves
* ADR cert-manager deployment changes by @SergeiSizov
* Tweak deeployment ds csi driver by @tmcalves
* deploy kubewarden by @SergeiSizov
* Disabling developer portal until it's fixed by @tmcalves
* move postgres initialization to the deployment by @robertgmoss
* Restrict alert to platform namespaces by @tmcalves
* add ingress className to kubewarden by @SergeiSizov
* Update dependencies by @kkonstan

## v0.22.0
### What's Changed
* updated contributing docs with release to corectl by @tombart
* more updates to onboarding docs by @tombart
* De-couple cert-manager from external-dns by @SergeiSizov
* cert-manager v1.15+ Gateway API is no longer behind a feature flag by @SergeiSizov
* update onboarding docs with latest requirements by @tombart
* 395: ensure repos field in tenant struct not nil by @tombart
* test(secret-manager): Debug tests in release workflow by @Mugenor
* test(secret-manager): undo: Debug tests in release workflow by @Mugenor
* bugs(platform-ingress): Move permission check for middleware from MTKA tests to platform-ingress tests, so the CRD is initialized by @Mugenor
* test(secret-manager): Debug tests in release workflow by @Mugenor
* test(secret-manager): undo: Debug tests in release workflow by @Mugenor
* bugs(platform-ingress): Move permission check for middleware from MTKA tests to platform-ingress tests, so the CRD is initialized by @Mugenor

## v0.20.0
### What's Changed
* Allow tenants to create middlewares by @tmcalves
* fix(mkta): rbac permissions for traefik middleware by @SennaSemakula
* Secret management feature by @tmcalves

## v0.19.0
### What's Changed
* feat(gcp): change default node disk type to ssd by @SennaSemakula
* Fix azure dependencies and re-enable sandbox-azure by @kkonstan
* Update dependencies by @kkonstan
* Add alerts for pod restarts and for containers in an erroring state by @tmcalves
* feat(gcp): add spot instances by @SennaSemakula

## v0.18.0
### What's Changed
* Set SSL alert to 20 days by @chbatey
* feat(adr): add default node boot disk for gke by @SennaSemakula
* rename label "cluster_name" to "cluster" as required by Slack template by @SergeiSizov
* bug(mtka): fix resource name roles, so permissions are granted correctly by @Mugenor
* feat(gcp): add option to change disk on additional node pools by @SennaSemakula

## v0.17.1
### What's Changed
* ADR reference app autoscaling by @SergeiSizov 
* tune sandbox-gcp size for prewarm by @SergeiSizov 
* Require k8s 1.29 by @kkonstan 
* Sync sandbox config by @SavvasM1 
* Add AWS related ADRs by @geomacy 
* Alerting for HPA and CA by @SergeiSizov 
* Add dummy test function to get rid of warning by @kkonstan 
* use GlobalRules resource when writing rules for Cloud Monitoring metrics by @SergeiSizov 
* Minior readme improvements by @chbatey 
* Per feature containers by @kkonstan 
* Add environment validation, fix schema by @kkonstan 
* feature(dod): require updating software templates as part of definition of done, if applicable by @Mugenor 
* chore(modules): add resource requests to missing workloads by @SennaSemakula 
* fix(gcp): add default values for additional node pools by @SennaSemakula 


## v0.16.0
### What's Changed
* feature(mtka): Give tenants permissions to create roles on their own by @Mugenor 
* feature(storage): Create StorageClass with regional replication by @Mugenor 
* adr(monitoring-stack): Describe storage redundancy decision by @Mugenor 
* bug(mtka): fix test bug after giving admin access to read everything by @Mugenor 
* increase resource max limit for sandbox clusters by @SergeiSizov 
* Remove release build time, replace with source date epoch by @kkonstan 
* Use p2p@v1 instead of p2p@main reusable workflows by @kkonstan 
* Switch from debian-slim to ubuntu by @kkonstan 
* Docker build cache improvements by @kkonstan 

## v0.15.1
### What's Changed
* feat(docs): Add Tenant Monitoring interface ADR by @SennaSemakula 
* chore(tenant-monitoring): cleanup by @Mugenor 
* bug(platform-monitoring): move tenant permissions test from MTKA to platform-monitoring by @Mugenor 
* Grant viewer role to p2p user by @SergeiSizov 

## v0.15.0
### What's Changed
* feature(tenant-monitoring): make it possible to deploy monitoring stack in tenant subnamespace by @Mugenor 
* feature(tenant-monitoring): make it possible to enable remote write for the prometheus by @Mugenor 
* feature(tenant-monitoring): tenant permissions to deploy monitoring-stack (grafana+prometheus) by @Mugenor 
* feat(docs): Tenant Monitoring - Grafana by @SennaSemakula 
* Switch avm-res-network-virtualnetwork to 0.2.3 by @kkonstan 
* Update dependencies by @kkonstan 
* validate beta features by @SergeiSizov 
* allow creation of rolebindings by admin role by @SergeiSizov 

## v0.14.1

### What's Changed
* feat(decisions): Add Tenant Monitoring Operator ADR by @SennaSemakula 
* Monitoring: Metric Store Chart by @SennaSemakula 
* feat(docs): Add Tenant Metric Store ADR by @SennaSemakula 
* feat(platform-monitoring): Add metric store helm chart publishing by @SennaSemakula 
* feat(prometheus-operator): Deploy prometheus operator conditionally by @Mugenor 
* Update tf providers by @kkonstan 
* feat(prometheus-operator): Functional tests for prometheus operator by @Mugenor 
* feat(tenant-monitoring): Add grafana instance to helm chart with prometheus instance by @Mugenor 
* Tenant Monitoring: Add GMP grafana datasource for kube-state-metrics by @SennaSemakula 
* initial azure platform-network implementation by @kkonstan 
* Install k6 operator by @SergeiSizov 
* ADR for K6 operator by @SergeiSizov 
* remove env config for k6-operator, always install by @SergeiSizov 
* adr(public-helm-charts): ADR on having public helm charts by @Mugenor 


## v0.13.1
### What's Changed
* GCP CNI decision  by @SavvasM1 
* ADR - Platform Ingress Autoscaling by @SergeiSizov 
* Destroy condition for post-destroy script had a wrong negation by @tmcalves 
* Add CI/CD support for Azure by @kkonstan 
* disable sandbox-azure connected-kubernetes by @kkonstan 
* Updating ADR by @petersjtaylor854 
* minor nitpicks by @kkonstan 
* hotfix connected-kubernetes post-destroy-script.sh by @kkonstan 
* allow API group "autoscaling" for tenants by @SergeiSizov 
* GCP Autoscaling & Node Pools by @SergeiSizov 
* Upgrade golang-ci-lint-action by @kkonstan 
* Make functional tests config.yaml aware by @SergeiSizov 

### Breaking Change

In this version we are introducing changes to the default node pool configuration for GKE.

Previously, the following node pools were configured by default:
- `${ENV_NAME}-4-pool` (e2-standard-4, 0-5 nodes) 
- `${ENV_NAME}-8-pool` (e2-standard-8, 0-5 nodes)
- `${ENV_NAME}-16-pool` (e2-standard-16, 0-5 nodes)

As we are introducing autoscaling with node auto-provisioning for GKE, we are no longer creating these node pools by default. 

> ⚠️ This may cause downtime for your services as legacy node pools will be destroyed and it will take time to reschedule your Pods on the new node pools provisioned by autoscaling. To keep the existing node pools add them as described below. Note the `name` needs to match with the ones listed above.

For the non-disruptive migration you may explicitly define the node pools that are currently used by your workloads in the `config.yaml` file, e.g.:

```yaml
cluster:
  gcp:
    additionalNodePools:
      - name: "4-pool"
        machineType: "e2-standard-4"
        minCount: 0
        maxCount: 5
```

If you wish to gradually migrate your workloads away from legacy node pools, you may do this by applying taints:

```yaml
cluster:
  gcp:
    autoscaling:
      cpuCores: 20
      memoryGb: 80
    additionalNodePools:
      - name: "4-pool"
        machineType: "e2-standard-4"
        minCount: 0
        maxCount: 5
        taints:
          - key: "legacyPool"
            value: "true"
            effect: "PREFER_NO_SCHEDULE"
```


