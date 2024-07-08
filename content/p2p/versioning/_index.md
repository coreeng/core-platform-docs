+++
title = "Versioning"
weight = 1
chapter = false
pre = ""
+++

The P2P starts with a versioned immutable artifact that is passed through the pipeline.

Versioning is a critical part of the software development lifecycle. It allows you to track changes to your codebase, and it helps you to understand what changes have been made and why. Versioning also helps you to manage dependencies and to ensure that your code is always up-to-date.

## Semantic Versioning Support

The P2P comes with a workflow that creates semantic versions for your application.

```
  version:
    uses: coreeng/p2p/.github/workflows/p2p-version.yaml@v1
    secrets:
      git-token: ${{ secrets.GITHUB_TOKEN }} 
```

When not on the main branch this will take the latest tag and append a commit hash.

When on main it increments the next minor version.
Everything in the pipeline after this works on that version.

## Incrementing the major version

To increment the major version, create the tag `vX.0.0` where X is the next major version you want to use.

The next time the P2P runs it will pick `vX.1.0` as the next version.
