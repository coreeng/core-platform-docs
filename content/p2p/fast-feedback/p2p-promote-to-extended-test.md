+++
title = "Promote to Extended Test"
weight = 6
chapter = false
pre = ""
+++

Make target: `p2p-promote-to-extended-test`

After successful run of `p2p-functional`, `p2p-integration`, and `p2p-nft` the version is considered ready for
extended test.

The default implementation as provided by software templates rarely needs changing:

```
p2p-promote-to-extended-test:
    corectl p2p promote <app-name>:${VERSION} \
        --source-stage $(FAST_FEEDBACK_PATH) \
        --dest-registry $(REGISTRY) \
        --dest-stage $(EXTENDED_TEST_PATH)
```

This moves the immutable versioned artifact into the registry for extended test and will be
picked up next time [extended test](/p2p/extended-test) runs
