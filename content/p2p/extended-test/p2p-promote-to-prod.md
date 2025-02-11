+++
title = "Promote to extended test"
weight = 6
chapter = false
pre = ""
+++

Make target: `p2p-promote-to-prod`

After successful run of `p2p-extended` the version is ready for production deployment.

The default implementation as provided by software templates rarely needs changing:

```sh
p2p-promote-to-prod:
    corectl p2p promote <app-name>:${VERSION} \
        --source-stage $(EXTENDED_TEST_PATH) \
        --dest-registry $(REGISTRY) \
        --dest-stage $(PROD_PATH)
```

This moves the immutable versioned artifact into the registry for production and will be
picked up next time [prod deploy](/p2p/prod) runs.
