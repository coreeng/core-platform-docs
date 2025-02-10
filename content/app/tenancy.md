+++
title = "Onboarding"
weight = 2
chapter = false
pre = ""
+++

Creating a tenancy is how you onboard onto Core Platform.
If you already have a tenancy, you can jump to [new-app](./new-app/) to deploy a new application.

### Adding a tenancy

```shell
corectl tenants create
```

You'll be prompted for the following information about your new tenant:

- `name` - Name of your tenancy. Must be the same as your filename.
- `parent` - Name of the parent tenant or `root`. Note: `root` tenant is created implicitly.
- `description` - Description for your tenancy.
- `contactEmail` - Metadata: Who is the contact for this tenancy?
- `environments` which of the environments in Environments Repo you want to deploy to
- `adminGroup` - will get permission to do all actions in the created namespaces - optional
- `readonlyGroup` - will get read-only access to the created namespaces - optional

{{% notice warn %}}

Both `adminGroup` and `readonlyGroup` are optional fields.
However, without these set, the secret management feature will not work.
You can still have access to tenant's namespaces by being in the parents admin and read-only groups,
as it will inherit permissions to access children's resources, with the exception of the secrets.

{{% /notice %}}

{{% notice warn %}}

You are encouraged
to use different `adminGroup` and `readonlyGroup` for each tenant because of cloud restrictions and security reasons.
Maximum number of duplicated `adminGroup` or `readonlyGroup` is 20.

{{% /notice %}}

Once you fill the form, `corectl` will create a PR in the Environments Repo with a new file for the tenancy.
Once the PR is merged, a configuration for the new tenant will be provisioned automatically.

In order to see your new tenancy in `corectl` you will need to run

```shell
corectl config update
```

{{% notice note %}}
Groups need to be in the `gke-security-groups` group!
If you are a new tenant the the platform, you should create new admin and readOnly groups and either ask a platform operator to add them
to `gke-security-groups` or add those groups to an already existing member of that group like `platform-readonly`.
{{% /notice %}}

## Accessing your namespaces

Once the above PR that `corectl` creates is merged everyone in the groups will have access to the namespaces created for that tenancy.

If you access the cluster from the local machine, you need to connect to the cluster.
The easiest way to do this is using `corectl`:

```shell
corectl env connect <env-name>
```

For example, to check a namespace for a tenancy named `myfirsttenancy`:

```shell
kubectl get namespace myfirsttenancy
NAME             STATUS   AGE
myfirsttenancy   Active   30s
```
