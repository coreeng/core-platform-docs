+++
title = "Debug Cloud Access issues"
weight = 9
chapter = false
pre = ""
+++

## Create gcloud-debug pod

In order to determine whether the problem lies in the application code or is an issue with GCP permissions, you can
deploy a `gcloud-debug` pod to your tenant namespace. This pod can use the same service account as your application,
allowing you to perform operations directly using the `gcloud` CLI.

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

## Deploy gcloud-debug pod

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
