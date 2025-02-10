+++
title = "Repository structure"
weight = 4
chapter = false
pre = ""
+++

Recommended and opinionated repository structure for applications.

We distinguish between 3 types of repository structure:

1. Single app in repository
2. Multiple apps in repository
3. Multiple apps in repository that has to be deployed together

## Single App Structure

Simple structure where there is only one application in the repository.

```bash
/
├── .github/
│   └── workflows/
│       ├── app-fast-feedback.yaml
│       ├── app-extended-test.yaml
│       └── app-prod.yaml
├── Dockerfile
├── Makefile
├── src/
├── tests/
│   ├── functional/
│   ├── extended/
│   └── nft/
├── helm-charts/
└── README.md
```

Key points:

- There is only one p2p lifecycle
- All application code, tests, and deployment configurations reside in root directory

### Tenant and Namespace Structure

Namespace structure:

```bash
app-tenant
├── [s] app-tenant-extended
├── [s] app-tenant-functional
└── [s] app-tenant-nft
└── [s] app-tenant-integration

[s] indicates subnamespaces
```

A single tenant `app-tenant` is created as a root for the app.
To isolate resources related to specific lifecycle stage we create a subnamespaces via
[hierarchical namespaces](https://github.com/kubernetes-sigs/hierarchical-namespaces).
The `app-tenant` name is stored in a GitHub repository variable `TENANT_NAME`

### Corectl support

You can use `corectl` to create this structure executing following commands:

```bash
corectl tenant create <tenant-name>
corectl config update
corectl app create <app-name> --tenant <tenant-name>
```

## Multiple Apps with Workflow per App

This structure is designed for projects containing multiple independent applications, each with its own deployment lifecycle.

```bash
/
├── .github/
│   └── workflows/
│       ├── app1-fast-feedback.yaml
│       ├── app1-extended-test.yaml
│       ├── app1-prod.yaml
│       ├── app2-fast-feedback.yaml
│       ├── app2-extended-test.yaml
│       └── app2-prod.yaml
├── app1/
│   ├── Dockerfile
│   ├── Makefile
│   ├── src/
│   ├── tests/
│   │   ├── functional/
│   │   ├── extended/
│   │   └── nft/
│   └── helm-charts/
├── app2/
│   ├── Dockerfile
│   ├── Makefile
│   ├── src/
│   ├── tests/
│   │   ├── functional/
│   │   ├── extended/
│   │   └── nft/
│   └── helm-charts/
└── README.md
```

Key features:

1. Modular Application Structure:
   - Each application resides in its own directory (`app1/`, `app2/`).
   - Applications contain all necessary files and configurations, including `Dockerfile`, `Makefile`, source code, tests, and Helm charts.

2. Isolated Lifecycles:
   - GitHub Actions workflows are defined separately for each application.

3. Application-Specific Build and Deployment:
   - Each application has its own `Makefile` with tasks specific to that application.

### Tenant and Namespace Structure

Namespace structure:

```bash
parent-tenant
├── app1-tenant
│   ├── [s] app1-extended
│   ├── [s] app1-functional
│   └── [s] app1-nft
│   └── [s] app1-integration
└── app2-tenant
    ├── [s] app2-extended
    ├── [s] app2-functional
    └── [s] app2-nft
    └── [s] app2-integration

[s] indicates subnamespaces
```

Key aspects:

1. Hierarchical Structure:
   - A parent tenant serves as the root for all applications.
   - Each application has its own child tenant.

2. Isolated Testing Environments:
   - Subnamespaces are created for different testing stages (extended, functional, nft, integration) within each application's
     tenant.

3. Authentication:
   - The parent tenant is used for authenticating all applications' P2P workflows to GCP.

This structure provides a clear separation of concerns, allowing each application to be developed, tested, and deployed independently
while maintaining a cohesive project structure.

### Corectl support

You can create projects like this following the steps below:

1. Create a parent tenant `corectl tenant create <parent-tenant-name>`
2. Create an empty root repository `corectl app create <monorepo-name> --tenant <parent-tenant-name>`
3. Fetch tenant changes `corectl config update`
4. Create tenant for the app `corectl tenant create <app-tenant-name> --parent <parent-tenant-name>`
5. Create an app `cd <monorepo-name> && corectl app create <app-name> --tenant <app-tenant-name>`

## Multiple Apps with Shared Workflow (Coupled Workload)

This structure is optimized for projects comprising multiple tightly coupled applications that require simultaneous deployment and shared resources.

```bash
/
├── .github/
│   └── workflows/
│       ├── coupled-workload-fast-feedback.yaml
│       ├── coupled-workload-extended-test.yaml
│       └── coupled-workload-prod.yaml
├── app1/...
├── app2/...
├── coupled-workload/
│   ├── Makefile
│   ├── app3/
│   │   ├── Dockerfile
│   │   └── src/
│   ├── app4/
│   │   ├── Dockerfile
│   │   └── src/
│   ├── tests/
│   │   ├── functional/
│   │   ├── extended/
│   │   └── nft/
│   ├── helm-charts/
│   │   └── coupled-workload/
│   │       ├── Chart.yaml
│   │       ├── values.yaml
│   │       └── templates/
│   └── resources/
│       └── subns-anchor.yaml
└── README.md
```

Key features:

1. Unified Workload Structure:
   - All coupled applications reside within a single `coupled-workload/` directory.
   - Each application (`app3/`, `app4/`) contains its `Dockerfile` and `src/` directory.
   - A shared `Makefile` at the workload level manages build and deployment tasks for all applications.

2. Consolidated Testing:
   - Tests are conducted at the workload level, encompassing all applications.
   - The `tests/` directory includes subdirectories for different testing phases: `functional/`, `extended/`, `integration/` and `nft/` (non-functional tests).

3. Unified Helm Chart:
   - A single Helm chart (`helm-charts/coupled-workload/`) is used for the entire workload.
   - The main `Chart.yaml` and `values.yaml` files define the overall workload configuration.
   - Subcharts for individual applications ideally stored externally

4. Shared Lifecycle:
   - GitHub Actions workflows are defined for the entire workload, not individual applications.

5. Resource Management:
   - The `resources/` directory contains shared configuration files, such as `subns-anchor.yaml` for namespace management.

### Tenant and Namespace Structure

```bash
parent-tenant
└── coupled-workload
    ├── [s] coupled-workload-extended
    ├── [s] coupled-workload-functional
    └── [s] coupled-workload-nft
    └── [s] coupled-workload-integration

[s] indicates subnamespaces
```

Key aspects:

1. Hierarchical Tenant Structure:
   - A parent tenant serves as the root for the coupled workload.
   - The coupled workload has a single child tenant, promoting unified resource management.

2. Shared Namespace Environments:
   - Subnamespaces are created for different testing environments (extended, functional, nft, integration) within the coupled workload tenant.
   - All applications in the workload share these namespaces, facilitating integrated testing and deployment.

3. Resource Isolation:
   - The use of subnamespaces allows for resource isolation between different testing phases while maintaining a cohesive structure.

4. Simplified Access Control:
   - The shared tenant structure simplifies access control and authentication mechanisms for the entire workload.

### Corectl support

Corectl doesn't fully support this structure. We don't recommend this approach for newly created projects and it
should be only used for existing projects that already have coupled workloads.

It is possible to setup required tenents via corectl.

```bash
corectl tenant create <parent-tenant-name>
corectl tenant create <app-tenant-name> --parent <parent-tenant-name>
```

### Manual configuration

You need to manually configure the following:

1. Helm charts
2. Makefile

#### Helm chart

Helm chart contains subchart for each app. Ideally, the subchart should point to a helm chart hosted
externally for better versioning support.

Sample `Chart.yaml`

```yaml
apiVersion: v2
name: coupled-workload
description: Helm chart for a coupled workload made up of two services
type: application
version: 0.1.0
appVersion: "1.16.0"
dependencies:
  - name: app
    alias: "app-3"
    version: "1.0.0"
    repository: "https://coreeng.github.io/core-platform-assets"
  - name: app
    alias: "app-4"
    version: "1.0.0"
    repository: "https://coreeng.github.io/core-platform-assets"
```

Configuration can be done via `values.yaml` file like below:

```yaml
common:
  resources:
    limits: &limits
      cpu: 500m
      memory: 100Mi

app-3:
  appName: app-3
  resources:
    requests:
      cpu: 300m
      memory: 50Mi
    limits: *limits

app-4:
  appName: app-4
  resources:
    requests:
      cpu: 300m
      memory: 50Mi
    limits: *limits
```

#### Makefile

We need to modify standard p2p Makefile to accommodate multiple docker images.

1. Modify the `p2p-build` target to build the images for each app

   ```makefile
   .PHONY: p2p-build
   p2p-build: service-build service-push

   .PHONY: service-build
   service-build:
      @echo $(REGISTRY)
      @echo 'VERSION: $(VERSION)'
      @echo '### SERVICE BUILD ###'
      docker build --platform=linux/amd64  --file ./app-3/Dockerfile --tag $(REGISTRY)/$(FAST_FEEDBACK_PATH)/$(app_3_image_name):$(image_tag) ./app-3
      docker build --platform=linux/amd64 --file ./app-4/Dockerfile --tag $(REGISTRY)/$(FAST_FEEDBACK_PATH)/$(app_4_image_name):$(image_tag) ./app-4

   .PHONY: service-push
   service-push: ## Push the service image
      @echo '### SERVICE PUSH FOR FEEDBACK ###'
      docker image push $(REGISTRY)/$(FAST_FEEDBACK_PATH)/$(app_3_image_name):$(image_tag)
      docker image push $(REGISTRY)/$(FAST_FEEDBACK_PATH)/$(app_4_image_name):$(image_tag)
   ```

2. Modify promotion target to promote the images for each app

   ```makefile
   .PHONY: p2p-promote-generic
   p2p-promote-generic:  ## Generic promote functionality
      corectl p2p promote $(image_name):${image_tag} \
         --source-stage $(source_repo_path) \
         --dest-registry $(REGISTRY) \
         --dest-stage $(dest_repo_path)

   promote-app-3-extended: source_repo_path=$(FAST_FEEDBACK_PATH)
   promote-app-3-extended: dest_repo_path=$(EXTENDED_TEST_PATH)
   promote-app-3-extended: image_name=$(app_3_image_name)
   promote-app-3-extended: p2p-promote-generic

   promote-app-4-extended: source_repo_path=$(FAST_FEEDBACK_PATH)
   promote-app-4-extended: dest_repo_path=$(EXTENDED_TEST_PATH)
   promote-app-4-extended: image_name=$(app_4_image_name)
   promote-app-4-extended: p2p-promote-generic


   # Promote both images
   .PHONY: p2p-promote-to-extended-test
   p2p-promote-to-extended-test: promote-app-3-extended promote-app-4-extended
   ```

3. Modify deployment

   ```makefile
   functional-deploy: namespace=$(tenant_name)-functional
   functional-deploy: path=$(FAST_FEEDBACK_PATH)
   functional-deploy: deploy

   deploy:
   helm upgrade --install $(helm_release_name) $(helm_chart_path)   \
         -n $(namespace) \
            --set app-3.registry=$(REGISTRY)/$(path) --set app-3.image=$(app_4_image_name) --set app-3.tag=$(VERSION) \
            --set app-4.registry=$(REGISTRY)/$(path) --set app-4.image=$(app_3_image_name) --set app-4.tag=$(VERSION)
   ```
