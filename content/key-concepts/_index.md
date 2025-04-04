+++
title = "Key Concepts"
weight = 1
chapter = false
+++

This document provides an overview of the key concepts and features that make up our platform. Each section links to a detailed page with more information.

## [Platform Environment](./platform/environment/)

A **Platform Environment** is the underlying infrastructure for **Application Environments**. It automatically scales based on deployed applications and ensures isolation between **Dev** and **Prod** to minimize risks. Each environment has predefined workflows to test, validate, and publish applications, ensuring stability and reliability.

## [Tenancy](./reference/tenancy/)

A **Tenancy** is the unit of access to the Core Platform. It includes read-only and admin groups and grants **CI/CD actors (GitHub Actions)** access to a **namespace** and a **Docker registry** for images. Once a tenancy is created, sub-namespaces can be added for application testing needs.

## [Application](./app)

An **Application** is a deployable service or software component that runs on the Core Platform. When created using core platform, a repository is automatically generated with a demo application that includes full continuous delivery.

## [Path to Production (P2P)](./p2p)

**Path to Production (P2P)** is the **GitHub Workflows** tool we provide for tenants to deploy their applications. It automates the deployment process and ensures smooth transitions between environments.

For more details, click on each feature to access its corresponding page.
