+++
title = "Alert runbooks"
weight = 10
chapter = false
pre = ""
+++

### Alerts runbooks

This contains a collection of runbooks that need to be followed for each alert raised on the platform.
Each alert should contain a short description and a deep link to the corresponding alert in this document.

##### KubePodCannotConnectToInternet

1. Is this affecting pods network and node network too?

   Run a pod on the host network
    ```
    kubectl run testbox --rm -it --image ubuntu:18.04 --overrides='{ "spec": { "hostNetwork" : true }  }' -- /bin/bash 
    ```

   Then check you can reach the internet.
    ```
    apt-get update && apt-get install curl -y
    curl https://www.google.com
    ```

   Is that fails, check your NAT Gateway.

2. Is the Cloud NAT configured correctly?

