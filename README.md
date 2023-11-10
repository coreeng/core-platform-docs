# Reference Knowledge Platform Deployment

Extend the CECG Knowledge Platform to add custom content and deploy to the CECG Develoepr Platform.

For deployment, the following variables need to be set:

* PROJECT_ID: The GCP Id of the project. You can see this in the GCP console page.
* PROJECT_NUMBER: Similar to project id, this is the numeric values for the GCP project. You can see this value in GCP console next to the project id.
* TENANT_NAME: Name of your tenant. There is a namespace created with the same name as your tenant and that will be used as a parent namespace.

## Building Locally

```
docker build . -t local-kp && docker run -p 8080:8080 local-kp
```

Then access the knowledge-platform [here](http://localhost:8080)

