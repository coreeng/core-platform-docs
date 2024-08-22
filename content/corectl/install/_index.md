+++
chapter = false
title = "Install Core Platform CLI"
weight = 100
+++

## Install `corectl` binary
### From release
You can find release versions of `corectl` [here](https://github.com/coreeng/corectl/releases).

```bash
VERSION='0.18.0'
# Darwin is for MacOS, Linux is for Linux
# Note: Windows is not supported
OS='Darwin' 
# If OS==Darwin, ARCH=arm64 is for Apple Silicon, otherwise it's x86_64
ARCH='arm64' # or x86_64
# Download release
curl -L https://github.com/coreeng/corectl/releases/download/v${VERSION}/corectl_${OS}_${ARCH}.tar.gz > corectl.tar.gz

# Extract binary
tar -xzvf corectl.tar.gz corectl

# Make binary accessible in $PATH
sudo mv ./corectl /usr/local/bin/corectl
```

### From source
To install `corectl` from source, you need to have [Go](https://go.dev/learn/) installed.

```bash
git clone https://github.com/coreeng/corectl.git
cd corectl
make install
```
