+++
title = "Multi-App Repos"
weight = 2
chapter = false
pre = ""
+++

If you want to have multiple applications in the same reposityroy i.e. a team "mono repo". Here is how you do it.

### Create an application as part of a monorepo

{{% notice note %}}
The recommended pattern is to create a tenant for the monorepo, and individual child tenants of that per application. See [Tenancy](./tenancy) for tenant creation.
{{% /notice %}}

Instead of creating a new repository for each of the applications, you can create a single repository
and add the applications as sub-directories.

First create a new root repository

```shell
corectl apps create <new-monorepo-name> --tenant <tenant-name> --non-interactive
        ```

        This will create an empty repository with necessary variables preconfigured for the P2P to work.

        You should first setup an application specific sub-tenant - this will be a child tenant of the above.

        Now create a new application in the sub-directory. You will be prompted for a template to use.

        ```shell
        cd <new-monorepo-name>
            corectl app create <new-app-name> --tenant <app-specific-child-tenant-name>
                    ```

                    Your new application will be created in a new PR for a monorepo. This will give you a chance to review the changes.
                    Once you're happy with the changes, merge the PR.
