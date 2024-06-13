+++
title = "Control Plane and Node Upgrades"
weight = 4
chapter = false
pre = ""
+++

## Background on GKE versions

In GKE, you cannot specify an exact control plane Kubernetes version. You also cannot downgrade what's currently
deployed. What you can do though, is set the minimum kubernetes version you want applied to your cluster.

The versions you get are influenced by Release Channels. Being subscribed to a Release Channel is generally considered a good practice for most,
and the Release Channel you are subscribed to dictates the versions that you have available.
For further information on this subject, take a look at [this](https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels) in depth documentation.

Without going into too much depth, there are currently 3 Release Channels:

#### RAPID

This channel delivers the absolute latest features, but with the caveat that these features may not be fully proven in
production environments. It's ideal for staying on the bleeding edge but comes with potential risks.

#### REGULAR

This is the default option and strikes a balance between providing new features and ensuring stability.
Upgrades happen every few weeks, giving you access to new features without being the first adopter.

#### STABLE

This channel prioritizes stability and only receives the most well-tested updates. Upgrades occur less frequently than
the Regular channel, making it suitable for production workloads requiring maximum uptime and reliability


#### Not subscribing to a release channel

As mentioned above, if you do not explicitly define your release channel, it will default to `REGULAR`. What you can do
though is explicitly define the release channel to either `null` or `unspecified`, at which point you will not be subscribed to any release channel.

GKE will still upgrade your clusters on a scheduled basis, usually move them on to the next minor version, and apply security patches.
There's various pros and cons to not being subscribed, but some key points are:

**Benefits**

* More control over the timing of your upgrades
* Can stay on a specific Kubernetes version for a longer time

**Drawbacks**

* Manual management is required, you will have to keep an eye out for newer Kubernetes versions and security patches and apply those yourself
* Some security risks are also involved as if you don't update in a timely manner your cluster might become vulnerable to security exploits.

#### Our Channel

We are currently subscribed to the `REGULAR` channel.

#### Our Kubernetes version
We dynamically source our Kubernetes versions, via a datasource with version prefix filtering. 

The below is responsible for fetching versions that match the provided prefix.

```terraform
data "google_container_engine_versions" "region_versions" {
  provider       = google-beta
  location       = var.gcp_region # Region definition as versions can vary between regions
  version_prefix = "${local.k8s_version}." # This is the version filter, at the time of writing this, it's 1.29.
}
```

Subsequently, we set the `kubernetes_version` like so:

```terraform
kubernetes_version = data.google_container_engine_versions.region_versions.release_channel_latest_version.REGULAR
```

The `kubernetes_version` field is then implicitly mapped to the `min_master_version` field, since as mentioned [above](#background-on-gke-versions) you can't
explicitly declare a Kubernetes version, you can only declare the minimum you want installed in a cluster.


## Control Plane Upgrades

When a control plane update takes place, during a maintenance window or through a manual update, some downtime could be expected,
depending on the `Location` type of your cluster.

#### Zonal

The Zonal Kubernetes clusters only have one master node backing them, and when an upgrade is taking place, there could be
several minutes of master downtime. This means that `kubectl` stops working, and applications that require the Kubernetes API stop working.
You also can't make any cluster changes while the upgrade is taking place. Deployments, services and various other Kubernetes constructs still work during this time.

#### Regional

Regional clusters provide multi-zone, highly available Kubernetes masters(3 Zones). These masters are behind a loadbalancer, and upgrades
are being done in such a way that there is no disruption during an upgrade. The masters are upgraded once at a time, in no specific
order, and each one of the masters is unavailable only during it's upgrade duration.

#### Our Location Type

We utilize `Regional` clusters, meaning that downtime should be kept to the minimum while upgrading the control plane.

## Node upgrades

When it comes to upgrading your nodes, there's more than a single strategy. That being said, between the strategies, some steps remain common:

* The node to be upgraded is cordoned so no new pods can be scheduled on it
* The node to be upgraded is drained. All strategies respect the pod's `PDB`s(Pod Disruption Budgets) and
  `GracefulTerminationPeriod` setting (Up to an hour for `SURGE`, and configurable for `BLUE-GREEN`)

Depending on the strategy, node upgrades can take a few hours to finish.

Some factors that could affect the overall duration of the upgrade:

* [Very conservative Pod Disruption Budgets](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets)
* High pod `gracefulTerminationPeriod` configuration
* [Node Affinity interactions](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity)
* Attached Persistent Volumes (Detachment/Reattachment can take time)

#### The SURGE strategy

This strategy upgrades nodes in a rolling fashion. Nodes are drained of traffic, upgraded,
and brought back online while the remaining nodes continue handling traffic. Steps include:

* Provision a new node
* Wait for it to be ready
* Cordon and drain the node to be replaced so no new pods are scheduled on it while existing workloads can finish running
* Delete the node to be replaced

Keep in mind that resources need to be available for the new surge nodes to come up, otherwise GKE won't start a node upgrade.

**Primary Pros**

* Cost-effective
* Simpler
* Faster

**Primary Cons**

* Potential Downtime (Apps running on the drained nodes )
* No easy rollback(Requires manual downgrading of the affected nodes)
* Main audience should be stateless applications(Where disruptions are more tolerated)

#### The BLUE-GREEN strategy

This strategy involves GKE creating a new set of node resources (the "green" nodes), with the new node configuration before
evicting any workloads on the original resources (the "blue" nodes). It's important to note that GKE will keep the "blue" nodes until
all traffic have been shifted to the "green" nodes.

**Primary Pros**

* Rollback mid upgrade if issues arise are possible
* A safe space(green) for testing out the release
* As close to 0 downtime as possible

**Primary Cons**

* Significant cost
* Complexity
* Need to have much higher quota headroom than `SURGE` to work properly

#### Our node upgrade strategy
Both strategies have their use cases. In our case, 
we use the `SURGE` strategy, with `max_surge` set to 1 and `max_unavailable` set to 0.
What this means is that only one surge node is added at a time, thus one node is being upgraded, at a time. Also, pods can restart immediately
on the new surge node.

A `SURGE` strategy with the `max_surge` and `max_unavailable` values we use, is typically the slowest of the bunch(still much quicker that `blue-green`),
but the least disruptive. By tweaking those 2 values you can balance speed and disruption potential.

#### Our node versions

We do not explicitly set any version for our nodes, but we have 

```terraform
auto_upgrade  = true
```

in our `node_pool` configuration. What this means is that every time the Kubernetes control plane is upgraded,
a node upgrade is scheduled automatically for the next maintenance window, to match that version. Naturally, the node and control plane
versions won't be the same at all times, but it's fine as long as we adhere to the Kubernetes [version skew policy](https://kubernetes.io/releases/version-skew-policy/).