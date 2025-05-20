const app = {
  "deploying-applications": {},
  tenancy: {},
  "new-app": {},
  configuration: {},
  logs: {},
  "app-monitoring": {},
  ingress: {},
  troubleshooting: {},
  "how-tos": {
    title: "How Tos",
    items: {
      "lightweight-envs": {},
      "deploying-infrastructure": {},
      "autoscale-app": {},
      "connect-to-cloudsql": {},
      "connect-to-memstore": {},
      "create-projects-tenant-infra-folder": {},
      "setting-resource-requests": {},
      "ingress-with-basic-auth": {},
      "ingress-with-whitelist": {},
      "debug-cloud-access-issues": {},
      "login-docker-hub": {},
      "manage-secrets": {},
    },
  },
};
const p2p = {
  overview: {},
  versioning: {},
  "fast-feedback": {
    title: "Quality Gate: Fast Feedback",
    items: {
      overview: {},
      "p2p-build": {},
      "p2p-functional": {},
      "p2p-integration": {},
      "p2p-nft": {},
      "p2p-promote-to-extended-test": {},
    },
  },
  prod: {
    title: "Production Deployment",

    items: {
      overview: {},
      "p2p-prod": {},
    },
  },
  "extended-test": {
    title: "Quality Gate: Extended Test",

    items: {
      overview: {},
      "p2p-extended-test": {},
      "p2p-promote-to-prod": {},
    },
  },
  reference: {
    items: {
      "deployment-frequency": {},
      "extended-tests": {},
      overview: {},
      "p2p-locally": {},
      promotion: {},
    },
  },
};
const platform = {
  overview: {},
  "cluster-autoscaling": {},
  dns: {},
  "managed-services": {},
  "managing-environments": {},
  "minimise-costs": {},
  "platform-monitoring": {},
  "nat-gateway": {},
  environment: {},
  "platform-ingress": {},
  "master-and-node-upgrades": {},
  "internal-services": {},
  "alert-runbooks": {},
  impl: {
    title: "Platform Implementation",
    items: {
      alerting: {},
      grafana: {},
      "infra-connector": {},
      "metrics-collection": {},
      overview: {},
      tenancy: {},
    },
  },
  troubleshooting: {},
  "how-tos": {
    title: "How Tos",
    items: {
      "autoscale-cluster": {},
      "exclude-logs": {},
      "minimise-costs": {},
      "overprovision-pods": {},
      "setup-alerts": {},
      "sync-argocd-app": {},
      traefik: {},
    },
  },
};
const reference = {
  "multi-app-repos": {},
  tenancy: {},
  "repo-structure": {},
  resources: {},
  "app-autoscaling": {},
  "accessing-psa": {},
  "accessing-cloud-infra": {},
  "software-templates": {},
  "deploying-reference-apps": {},

  "secret-management": {},
};
const capabilities = {
  overview: {},
  roadmap: {},
  history: {},
};
const changelogs = {
  "core-platform": {},
  p2p: {},
  corectl: {},
};
const meta = {
  "*": {
    type: "page",
  },
  docs: {
    title: "Documentation",
    items: {
      index: "Overview",
      "key-concepts": {},
      corectl: {},
      app: {
        title: "Deploying Applications",
        items: app,
      },
      p2p: {
        title: "Path To Production",
        items: p2p,
      },
      platform: {
        title: "Platform Operations",
        items: platform,
      },
      reference: {
        title: "Reference",
        items: reference,
      },
      capabilities: {
        title: "Capabilities and Roadmap",
        items: capabilities,
      },
      changelogs: {
        title: "Changelogs",
        items: changelogs,
      },
    },
  },
  index: { display: "hidden" },
};
export default meta;
