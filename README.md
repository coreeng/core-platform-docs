# Core Platform Documentation

This repository contains assets to build and run the Core Platform documentation.

## Building Locally

This uses docker:

```shell
make run-local
```

Then access the docs [here](http://localhost:8080)

For fasterfeedback you can install [hugo](https://gohugo.io/) locally then run:

```shell
hugo serve
```

## Linting

You can use `markdownlint-cli2` to check your changes, this is the linter used by the [Markdown VSCode plugin](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)

```shell
npm install markdownlint-cli2 --global
make lint
```
