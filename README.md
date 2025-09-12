# Nextra Docs

Nextra docs application for the Core Platform.

# Parameters

The following environment variables are supported for runtime configuration:

| Environment variable | Required | Default                        | Description             |
| -------------------- | -------- | ------------------------------ | ----------------------- |
| `BASE_URL`           | No       | `https://docs.coreplatform.io` | Base url of the website |

# Path to Production (P2P)

The P2P uses GitHub Actions to interact with the platform.

As part of the P2P, using Hierarchical Namespace Controller, child namespaces will be created:

- `<tenant-name>-functional`
- `<tenant-name>-nft`
- `<tenant-name>-integration`
- `<tenant-name>-extended`

The application is deployed to each of this following the shape:

```
| Build Service | -> | Functional testing | -> | NF testing | -> | Integration testing | -> | Promote image to Extended tests |
```

The tests are executed as helm tests. For that to work, each test phase is packaged in a docker image and pushed to a registry.
It's then executed after the deployment of the respective environment to ensure the service is working correctly.

You can run `make p2p-help` to list the available make targets.

#### Requirements

The interface between the P2P and the application is `Make`.
For everything to work for you locally you need to ensure you have the following tools installed on your machine:

- Make
- Docker
- Kubectl
- Helm

#### Prerequisites for local run

To run the P2P locally, you need to connect to a cloud development environment.
The easiest way to [do that is using `corectl`](https://docs.coreplatform.io/platform#using-corectl).

Once connected, export all env variables required to run Makefile targets, see [Executing P2P targets Locally](https://docs.coreplatform.io/p2p/reference/p2p-locally)
for instructions.

#### Image Versioning

The version is automatically generated when running the pipeline in GitHub Actions, but when you build the image
locally using `p2p-build` you may need to specify `VERSION` when running `make` command.

```
make VERSION=1.0.0 p2p-build
```

#### Building on arm64

If you are on `arm64` you may find that your Docker image is not starting on the target host. This may be because of
the incompatible target platform architecture. You may explicitly require that the image is built for `linux/amd64` platform:

```
DOCKER_DEFAULT_PLATFORM="linux/amd64" make p2p-build
```

#### Push the image

There's a shared tenant registry created `europe-west2-docker.pkg.dev/<project_id>/tenant`. You'll need to set your project_id and export this string as an environment variable called `REGISTRY`, for example:

```
export REGISTRY=europe-west2-docker.pkg.dev/<project_id>/tenant
```

#### Ingress URL construction

For ingress to be configured correctly,
you'll need to set up the environment that you want to deploy to, as well as the base url to be used.
This must match one of the `ingress_domains` configured for that environment. For example, inside CECG we have an environment called `gcp-dev` that's ingress domain is set to `gcp-dev.cecg.platform.cecg.io`.

This reference app assumes `<environment>.<domain>`, check with your deployment of the Core Platform if this is the case.

This will construct the base URL as `<environment>.<domain>`, for example, `gcp-dev.cecg.platform.cecg.io`.

```
export BASE_DOMAIN=gcp-dev.cecg.platform.cecg.io
```

Read [more](https://docs.coreplatform.io/application/ingress) about Ingress.

#### Logs

You may find the results of the test runs in Grafana. The pipeline generates a link with the specific time range.

To generate a correct link to Grafana you need to make sure you have `INTERNAL_SERVICES_DOMAIN` set up.

```
export INTERNAL_SERVICES_DOMAIN=gcp-dev-internal.cecg.platform.cecg.io
```

## Functional Testing

Stubbed Functional Tests using [Cucumber JS](https://cucumber.io/docs/installation/javascript)

This namespace is used to test the functionality of the app. Currently, using BDD (Behaviour driven development)

## NFT

This namespace is used to test how the service behaves under load, e.g. 1k TPS, P99 latency < 1000 ms for 3 minutes run.

There are 1 endpoint available for testing:

- `/hello` - simply returns `Hello world`.

## Integration Testing

Integration Tests are using [Cucumber JS](https://cucumber.io/docs/installation/javascript)

This namespace is used to test that the individual parts of the system as well as service-to-service communication
of the app works correctly against real dependencies. Currently, using BDD (Behaviour driven development)

#### Load Generation

We are using [K6](https://k6.io/) to generate constant load, collect metrics and validate them against thresholds.

There is a test examples: [hello.js](./resources/load-testing/hello.js)

`helm test` runs K6 scenario in a single Pod.

#### Platform Ingress

We can send the traffic to the reference app either via ingress endpoint or directly via service endpoint.

There is `nft.endpoint` parameter in `values.yaml` that can be set to `ingress` or `service`.

## Extended test

This is similar to NFT, but generates much higher load and runs longer, e.g. 10k TPS, P99 latency < 1000 ms for 10 minutes run.

#### Load Generation

We are using [K6](https://k6.io/) to generate the load.
We are using [K6 Operator](https://github.com/grafana/k6-operator) to run multiple jobs in parallel, so that we can reach high
TPS requirements.

When running parallel jobs with K6 Operator we are not getting back the aggregated metrics at the end of the test.
We are collecting the metrics with Prometheus and validating the results with `promtool`.

#### Platform Ingress

We can send the traffic to the reference app either via ingress endpoint or directly via service endpoint.
See NFT section for more details.

## Platform Features

> Due to the restrictions applied to your platform you may not be able to enable some of the features

### Monitoring

This feature is needed to allow metrics collection by Prometheus. It needs the metric store (prometheus) to be installed on the parent namespace e.g. `TENANT_NAME`.

By default, Monitoring is disabled. In order to enable it, you need to explicitly override the variable

```
make MONITORING=true p2p-nft
```

or change `MONITORING` to `true` in `Makefile`.

### Dashboarding

This feature allows you to automatically import dashboard definitions to Grafana.

> You may import the dashboard manually by uploading the json definition via browser

By default, `DASHBOARDING` is disabled. In order to enable it, you need to explicitly override the variable

```
make DASHBOARDING=true p2p-nft
```

or change `DASHBOARDING` to `true` in `Makefile`.

The reference app comes with `10k TPS Reference App` dashboard that shows the TPS and latency
for the load generator, ingress, API server and its downstream dependency.

This feature depends on metrics collected by `Service Monitor`.

### K6 Operator

> K6 Operator must be enabled for the tenant to run the extended test

You can enable it by enabling the beta feature in the tenant.yaml file:

```yaml
betaFeatures:
  - k6-operator
```

## Limiting the CPU usage

When running load tests it is important that we define CPU resource limits. This will allow us to have stable results between runs.

If we don't apply the limits then the performance of the Pods will depend on the CPU utilization of the node that is running the container.
