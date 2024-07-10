+++
title = "Deploying the reference apps"
weight = 20
chapter = false
pre = ""
+++

All the software templates are published into a single [public repository] that can be forked
and configured to deploy to your Core Platform environments as a quick way of 
seeing a set of applications running.

## Deploying all the reference apps

For [Core Platform reference applications](https://github.com/coreeng/core-platform-reference-applications).

After forking, configure the P2P:

```
corectl p2p env sync <your-fork> <your-tenant>
```

You can then execute the workflows and the reference applications will be deployed to your environments.

{{% notice note %}}
After you have forked the core-platform-reference-applications repo, you need to do the following:
{{% /notice %}}
* Manually enable the workflows in your forked repository. To do this, navigate to your repository on GitHub. Click on the 'Actions' tab. If you see a notice about workflow permissions, click on 'I understand my workflows, go ahead and enable them'.

* In the Makefile of your repository, change the `tenant_name` variable to match the name of the tenancy you created."

