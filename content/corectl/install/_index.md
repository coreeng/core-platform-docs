+++
chapter = false
title = "Install Core Platform CLI"
weight = 100
+++

## Install `corectl` binary
### From release

* Install latest version
```bash
curl -sL https://raw.githubusercontent.com/coreeng/corectl/installation-script/corectl-cli-install.sh | sudo bash 
```
* Install specific version

You can find release versions of `corectl` [here](https://github.com/coreeng/corectl/releases).

```bash
curl -sL https://raw.githubusercontent.com/coreeng/corectl/installation-script/corectl-cli-install.sh | sudo CORECTL_VERSION="<choose-version>" bash 
```


### From source
To install `corectl` from source, you need to have [Go](https://go.dev/learn/) installed.

```bash
git clone https://github.com/coreeng/corectl.git
cd corectl
make install
```
