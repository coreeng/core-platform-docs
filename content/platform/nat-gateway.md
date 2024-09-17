+++
title = "Outbound Connections"
weight = 2
chapter = false
pre = ""
+++

## Outbound Connections

Cloud NAT (network address translation) lets certain resources in GCP create outbound connections to the
internet or to other Virtual Private Cloud (VPC) networks, on-premises networks, or other cloud provider networks. Cloud
NAT supports address translation for established inbound response packets only. It does not allow unsolicited inbound
connections.

## Outbound IP

By default, GCP allocates IP addresses automatically. The IP addresses are managed by GCP, added or removed based on the
outbound traffic. This is the default platform configuration. With automatic allocation, you cannot predict the next IP
address that is allocated. If you depend on knowing the set of possible NAT IP addresses ahead of time (for example, to
create an allowlist), you should use manual NAT IP address assignment instead.

## Static (Manual) Outbound IPs Assignment

The platform provides a feature that enables allocation of a number of static IP addresses that can be reserved upfront.
When using that feature, you must calculate the number of regional external IP addresses that you need for the
NAT gateway. If your gateway runs out of NAT IP addresses, it drops packets. You can increase or decrease the
number of allocated static IP addresses by updating platform environment configuration. Those IP addresses are reserved
and will remain so until you delete them. To enable this feature, we
use [Manual NAT IP address assignment with dynamic port allocation](https://cloud.google.com/nat/docs/ports-and-addresses#addresses)

### Platform environment configuration

```
network:
  publicNatGateway: # [Optional] configuration for the NAT Gateway
    ipCount: 2 # [Required] number of IP addresses to allocate
    logging: ERRORS_ONLY # [Optional] enable logging, available values: ERRORS_ONLY,TRANSLATIONS_ONLY,ALL, when not provided no logging is enabled, we recommend setting to ERRORS_ONLY
    minPortsPerVm: 64 # [Optional] min number of ports per VM, when not provided default (64) is used
    maxPortsPerVm: 128 # [Optional] max number of port per VM, when not provided default (32,768) is used
    tcpEstablishedIdleTimeoutSec: 1200 # [Optional] timeout (in seconds) for TCP established connections (default 1200), only update when necessary, otherwise leave default
    tcpTransitoryIdleTimeoutSec: 30 # [Optional] timeout (in seconds) for TCP transitory connections (default 30), only update when necessary, otherwise leave default
    tcpTimeWaitTimeoutSec: 120 # [Optional] timeout (in seconds) for TCP connections that are in TIME_WAIT state (default 120), only update when necessary, otherwise leave default
```

#### Recommended overrides

```
network:
  publicNatGateway: # [Optional] configuration for the NAT Gateway
    ipCount: <numbers of IPs to allocate>
    logging: ERRORS_ONLY # enable logging for packet drops due to NAT IP allocation
    minPortsPerVm: <set min number of ports per VM>
    maxPortsPerVm: <set max number of ports per VM>
```

## View assigned IP addresses

To view all assigned IP addresses to the NAT Gateway
follow [View NAT IP addresses assigned to a gateway](https://cloud.google.com/nat/docs/set-up-manage-network-address-translation#view_nat_ip_addresses_assigned_to_a_gateway)

## Increase allocated number of IP addresses

{{% notice warning %}}
Allocating more IP addresses might cause source IP changes to existing services for outbound requests. If third party
clients allowlisted specific IPs, they'll need to update their allowlist accordingly.
{{% /notice %}}

1. Calculate the number of IPs required. To understand your current NAT Gateway usage,
   see `NAT Gateway` dashboard in Grafana.
   For example of IP/ports calculations,
   see [Port reservation example](https://cloud.google.com/nat/docs/ports-and-addresses#port-reservation-examples). To
   define min number of ports per VM,
   see [Choose a minimum number of ports per VM](https://cloud.google.com/nat/docs/tune-nat-configuration#choose-minimum)
2. Update environment configuration file as
   per [Platform environment configuration](#platform-environment-configuration)

Cloud NAT gateway will dynamically allocate different number of ports per VM, based on the VM's usage. Min and max
ports settings are optional; however, it is strongly recommended to set those values to ensure strong tenant
isolation (misbehaving services won't acquire all available connections). For more information on port allocation
see [Ports](https://cloud.google.com/nat/docs/ports-and-addresses#ports) section.

{{% notice note %}}
Please note that NAT Gateway has GCP imposed limits, see [NAT limits](https://cloud.google.com/nat/quota#limits) for
details.
{{% /notice %}}

## Decrease allocated number of IP addresses

{{% notice warning %}}
Increasing the number of IPs is a safe operation; the existing connections won't be affected, however, decreasing the
value without draining the connections first will cause connection being terminated immediately.
See [Impact of tuning NAT configurations on existing NAT connections](https://cloud.google.com/nat/docs/tune-nat-configuration#impact-nat-tuning-existing-conns)
for further details.
{{% /notice %}}

All IP addresses are created sequentially, following naming convention `<env>-nat-ext-ip-<number>`, numbered from 0 to
X. During IP address reservation the platform stores those IPs in an ordered list. We recommend that you remove one IP
address at a time. Decreasing `network.publicNatGateway.ipCount` number by one causes removal of a last IP address in GCP,
therefore **make sure you drain last IP address**. In case you remove/drain the wrong address, the release fails as you
cannot delete addresses that are still allocated to NAT Gateway.

1. Ensure you'll choose the last created IP address; this is the address with the greatest number, following naming
   convention `<env>-nat-ext-ip-<number>`
2. Drain existing connections,
   see [Drain external IP addresses associated with NAT](https://cloud.google.com/nat/docs/set-up-manage-network-address-translation#draining)
3. Confirm that all connections associated with the IP addressed drained are closed. You can do so by
    1. checking `Port Allocation[NAT Gateway]` graph
       in `NAT Gateway` Grafana dashboard, there should be no port allocation from drained IP.
    2. enable NAT Logging by:
   ```
   network:
     publicNatGateway:
       logging: ALL
       ...
   ```
   and checking that there are no logs for open connections associated to drained IP address.
4. Remove drained IP address assignment from NAT Gateway in UI.
5. Update `network.publicNatGateway` configuration and release:

   ```
   network:
     publicNatGateway:
       ipCount: 2 # decrease this number to desired number of IP addresses
       ...
   ```
6. Notify any third parties on source IP changes for outbound connections so they can update their allowlists.

## Migrate to static (manual) IP allocation

{{% notice warning %}}
Switching IP assignment method is disruptive, and it breaks all active NAT connections. Further info can be found
in [Switch assignment method](https://cloud.google.com/nat/docs/ports-and-addresses#switching-nat-ip-method)
{{% /notice %}}

1. Update chosen environment configuration file as
   per [Platform environment configuration](#platform-environment-configuration)
2. Validate changes in
   GCP [IP addresses](https://console.cloud.google.com/networking/addresses/list), [NAT Gateway](https://console.cloud.google.com/net-services/nat/list)
3. Test outbound connection from the cluster
   ```
   kubectl run tmp-shell --rm -it --image nicolaka/netshoot -- /bin/bash # pod network
   kubectl run tmp-shell --rm -it --image nicolaka/netshoot --overrides='{ "spec": { "hostNetwork" : true }  }' -- /bin/bash # host network
   ```
   Once in the container run (if it fails, double check that Google is up
   on [uptime](https://uptime.com/upstatus/google.co.uk?start=20240821&end=20240821))
   ```
   curl -I www.google.com
   ```

## Migrate to automatic IP allocation

{{% notice warning %}}
Switching IP assignment method is disruptive, and it breaks all active NAT connections. Further info can be found
in [Switch assignment method](https://cloud.google.com/nat/docs/ports-and-addresses#switching-nat-ip-method)
{{% /notice %}}

1. Repeat [Decrease allocated number of IP addresses](#decrease-allocated-number-of-ip-addresses) until you'll be left
   with a single IP
2. Manually update NAT Gateway configuration in GCP UI to set `Cloud NAT IP addresses` field to `Automatic`, then save.
3. Test outbound connection from the cluster
   ```
   kubectl run tmp-shell --rm -it --image nicolaka/netshoot -- /bin/bash # pod network
   kubectl run tmp-shell --rm -it --image nicolaka/netshoot --overrides='{ "spec": { "hostNetwork" : true }  }' -- /bin/bash # host network
   ```
   Once in the container run (if it fails, double check that Google is up
   on [uptime](https://uptime.com/upstatus/google.co.uk?start=20240821&end=20240821))
   ```
   curl -I www.google.com
   ```
4. Remove `network.publicNatGateway` section from platform environment configuration and release.

### Troubleshooting

For troubleshooting Platform NAT Gateway see
Follow [NAT Gateway IP Allocation Failures](./troubleshooting#nat-gateway-ip-allocation-failures) section.
For more generic information on common issues and how to solve them with Cloud NAT
see [Troubleshooting guide](https://cloud.google.com/nat/docs/troubleshooting)
