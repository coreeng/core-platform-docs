+++
title = "Build"
weight = 1
chapter = false
pre = ""
+++

The purpose of P2P build is to

* Run any local tests + static verification
* Build an immutable versioned artifact to pass through the rest of the P2P.

## Pushing to the fast feedback registry

For deployed testing to take place push a versioned artifact:

```
docker image push $(REGISTRY)/$(EXTENDED_TEST_PATH)/<app-name>:$(VERSION)
```

Variables set by the P2P that you can use:
* REGISTRY
* VERSION
