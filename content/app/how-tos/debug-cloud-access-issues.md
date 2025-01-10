+++
title = "Debug Cloud Access issues"
weight = 9
chapter = false
pre = ""
+++


## Validate configuration

To get you started, ensure you've followed the [access cloud infrastructure documentation](../../../app/accessing-cloud-infra)
Having done that we can start debugging.

### Check tenant configuration

Go to the `platform-environments` repo and ensure your tenant has it is properly configured.

```yaml
cloudAccess:
  - name: ca
    provider: gcp
    environment: all
    kubernetesServiceAccounts:
      - <your_namespace>/<sa-name>
```

Looking at `kubernetesServiceAccounts`:

* Have your changes been merged?
* Has the pipeline finished?
* Is the namespace you're trying to connect from listed there?
* Is the Service Account name matching? The kubernetes Service Account being used by your deployment/pod needs to match exactly what is defined there?

### Tenant Provisioner status

In case all above looks correct, there might be exceptional issues with the tenant provisioner. In this case, you should reach
out to a *platform operator* and ask them to check the status of the tenant provisioning of your tenant. This functionality will be added to corectl in
a future release.

## Validate permissions

### Failure on CI

If the issue is on CI creating the resources/connecting to your account, it might be an issue with the configured service account.
Out of the box, the SA using on GH actions will work to deploy to your tenant's namespace in the Kubernetes Cluster, to use the same SA to deploy your infrastructure
in a different GCP account, you need to ensure that SA has permission to do so

#### Validate that the p2p service account has enough permission on your own GCP project

The p2p Service account needs permission to deploy the infrastructure

The Principal will be `p2p-<tenantName>@<platformProjectId>.iam.gserviceaccount.com`

The role of Owner will allow it to create anything it needs, feel free to make this more restrictive.

{{< figure src="images/how-to/debug-cloud-access/debug-cloud-access.png" title="Namespace Dashboard" >}}

## Deploy gcloud-debug pod

### Failure on the application

In order to determine whether the problem lies in the application code or is an issue with GCP permissions, you can
deploy a `gcloud-debug` pod to your tenant namespace. This pod can use the same service account as your application,
allowing you to perform operations directly using the `gcloud` CLI.

### Create gcloud-debug pod

### Example Kubernetes manifest file for gcloud-debug pod

#### gcloud-debug-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: gcloud-debug
  labels:
    app: gcloud-debug
spec:
  serviceAccountName: <service_account_name>
  containers:
    - name: gcloud-debug
      image: google/cloud-sdk:latest
      imagePullPolicy: IfNotPresent
      command: ["/bin/sh"]
      args: ["-c", "sleep 3600"]
```

This can help you understand if the issue is on your own GCP Account that hasn't give enough permissions to the service account.

This pod can be deployed to your namespace with:

```shell
kubectl apply -f gcloud-debug-pod.yaml --namespace ${NAMESPACE}
```

## Use gcloud-debug pod for debugging

Once the pod has been deployed, you can open a shell into it:

```shell
kubectl exec -it gcloud-debug --namespace ${NAMESPACE} -- /bin/sh
```

You can now use the `gcloud` CLI as your service account. To verify that the service account is being used, check the
output of `gcloud auth list`.

## Cleanup

After debugging, remember to delete the gcloud-debug pod to clean up your namespace:

```shell
kubectl delete pod gcloud-debug --namespace ${NAMESPACE}
```

If none of these work, reach out to a platform operator to drill down for any exceptional causes.
