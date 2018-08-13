---
layout: page
title: Connecting the Real and the Simulated World
hidden: true
---

## Goals

Ping is a basic Internet program that allows a user to verify that a particular IP address exists and can accept requests. Ping is used diagnostically to ensure that a host computer the user is trying to reach is actually operating. INET features a way to simulate ping between hosts.

This showcase presents the emulation feature of the INET framework by performing "ping traffic" in simulated and emulated models.

INET version: `4.0`<br>
Source files location: <a href="https://github.com/inet-framework/inet-showcases/tree/master/emulation/pingpong" target="_blank">`inet/showcases/emulation/pingpong`</a>

## About ping

Ping is a computer network administration software utility used to test the reachability of a host on an Internet Protocol (IP) network. It measures the round-trip time for messages sent from the originating host to a destination computer that are echoed back to the source.

Ping operates by sending Internet Control Message Protocol (ICMP) echo request packets to the target host and waiting for an ICMP echo reply.

## The model

### The network

This showcase presents three different scenarios.

**Fully Simulated Network**

The first example presented in this showcase is a fully simulated network. The network consist of two hosts (`host1` and `host2`) and a 100Mbps Ethernet connection between them. The following image shows the layout of the first network:

<a href="pingpong_layout_1.png" target="_blank"><img class="screen" src="pingpong_layout_1.png"></a>

**First Emulated Network**

The second example presents an emulated network, consisting of one simulated node called `host1`. The other parts of the network, from the `ExtLowerEthernetInterface` of `host1` are not part of the simulated environment. The simulated side of the network can be seen in the following picture:

<a href="pingpong_layout_2.png" target="_blank"><img class="screen" src="pingpong_layout_2.png"></a>

**Second Emulated Network**

In the third example, there is a simulated node, `host1`, and a a simulated connection between `host1` and `host2`. The layout of the third network is the same as it was with the fully simulated scenario, although `host2` is not part of the simulation:

<a href="pingpong_layout_1.png" target="_blank"><img class="screen" src="pingpong_layout_1.png"></a>

### Configuration and behaviour

**Important!** Please make sure to follow the steps on the [previous page](../) to set the application permissions!

The showcase involves three different configurations:
- `Simulated:` A fully simulated model with two nodes and a 100Mbps Ethernet connection between them.
- `Emulated1:` One of the nodes is simulated, the other node and the connection is in the real operating environment.
- `Emulated2:` One of the nodes and the 100Mbps Ethernet connection is simulated, the other node is in the real operating environment.

In all the three examples the `PingApp` of the simulated `host1` sends ping packets with the destination address of `192.168.2.2`.

<p><pre class="snippet" src="../../emulation/pingpong/omnetpp.ini" from="numApps" until="####" comment="#!"></pre></p>

**`Simulated` configuration**

There is no need for any other parameter to be set in the `Simulated` configuration.

**`Emulated1` configuration**

The `Emulated1` configuration uses the `ExtLowerEthernetInterface` provided by INET. This is a socket based external ethernet interface. Before running the emulation, there are some preparations that need be done. The `Emulation1` configuration is run using virtual ethernet devices, called `vetha` and `vethb`. These two devices need to be created and configured. This is achieved as the following:

<p><pre class="snippet" src="../../emulation/pingpong/setup1.sh" comment="#!"></pre></p>

**Note:** *veth (virtual ethernet device): they can act as tunnels between network namespaces to create a bridge to a physical network device in another namespace, but can also be used as standalone network devices. The veth devices are always created in interconnected pairs.*

We can see that `vethb` gets the IP address `192.168.2.2`, which is the same as the destination Address of `host1`'s `PingApp`. In this emulation `host1` pings `vethb` through `vetha`.

<p><pre class="snippet" src="../../emulation/pingpong/omnetpp.ini" from="Emulated1" until="####" comment="#!"></pre></p>

It is important that the TAP device used in the `Emulated2` configuration and the veth devices used in the `Emulated1` configuration do not exist at the same time during an emulation. The reasun for that is that both `vethb` and `tapa` have the same IP address, which can falsify the results. So it is highly recommended to destroy the virtual ethernet link after running the `Emulated1` configuration:

<p><pre class="snippet" src="../../emulation/pingpong/teardown1.sh" comment="#!"></pre></p>

**`Emulated2` configuration**

The `Emulated2` configuration uses the `ExtUpperEthernetInterface` provided by INET. This emulation is with real TAP interface connected to the simulation. For this reason the `tapa` TAP interface need to be created and configured before the `Emulation2` configuration is run:

<p><pre class="snippet" src="../../emulation/pingpong/setup2.sh" comment="#!"></pre></p>

**Note:** *Linux and most other operating systems have the ability to create virtual interfaces which are usually called TUN/TAP devices. Typically a network device in a system, for example eth0, has a physical device associated with it which is used to put packets on the wire. In contrast a TUN or a TAP device is entirely virtual and managed by the kernel. User space applications can interact with TUN and TAP devices as if they were real and behind the scenes the operating system will push or inject the packets into the regular networking stack as required making everything appear as if a real device is being used.*

In this configuration we do not need the configurator to set the IP address of `host2`, because `host2` uses the `tapa` real TAP interface, to which the proper IP address was previously assigned.

<p><pre class="snippet" src="../../emulation/pingpong/omnetpp.ini" from="Emulated2" until="####" comment="#!"></pre></p>

It is recommended to destroy the TAP interface if the emulation is finished and it is not needed anymore:

<p><pre class="snippet" src="../../emulation/pingpong/teardown2.sh" comment="#!"></pre></p>

## Results

This time the simulations are run from the terminal in order to show the above detailed preparations as well.

#### `Simulated` configuration

There are no preparations needed for the `Simulated` configuration to run. As the video confirms, this is a fully simulated model, which runs in a simulated environment. No real network interfaces of the computer are influenced by the simulation, meaning that no extra traffic appears on them:

<p>
<video autoplay loop controls src="Simulated_EDIT.mp4" type="video/mp4" onclick="this.paused ? this.play() : this.pause();">Your browser does not support HTML5 video.</video>
<!--Emulation proof-->
</p>

#### `Emulated1` configuration

As mentioned above, this configuration uses the `ExtLowerEthernetInterface` offered by INET. This external interface acts as a bridge between the simulated and the real world. From this module on, the emulation enters the real operation environment of the OS. The following video shows how the traffic rate of the virtual ethernet devices changes, while the emulation is running. Right at the beginning of the video, you can also take a look at the previous configurations that needed to be done for the emulation to run without errors:

<p>
<video autoplay loop controls src="Emulated1_EDIT.mp4" type="video/mp4" onclick="this.paused ? this.play() : this.pause();">Your browser does not support HTML5 video.</video>
<!--Emulation proof-->
</p>

The change in the traffic rate of `vetha` and `vethb` is conspicuous when the emulation is started.

#### `Emulated2` configuration

In this configuration, the `ExtUpperEthernetInterface` is used. In a sense this interface is similar to the `ExtLowerEthernetInterface` used in the `Emulated1` configuration, meaning that it acts as a bridge between the simulated and the real world. If we run the `Emulated2` configuration and observe the traffic rate of the `tapa` TAP interface, we can conclude that `host1` is indeed pinging the real TAP interface:

<p>
<video autoplay loop controls src="Emulated2_EDIT.mp4" type="video/mp4" onclick="this.paused ? this.play() : this.pause();">Your browser does not support HTML5 video.</video>
<!--Emulation proof-->
</p>

## Conclusion

We can clearly see that using the external interfaces, the emulation can switch between the real and the simulated environment. This emulation feature of INET makes it possible for the user to "cut" the network at arbitrary points into many pieces and leave some of it in the simulation while extracting the others into the real world.

## Further Information

The following link provides more information about ping in general:
- <a href="https://en.wikipedia.org/wiki/Ping_(networking_utility)" target="_blank">ping (networking utility)</a>

The network traffic is observed using <a href="https://github.com/tgraf/bmon" target="_blank">bmon</a>, which is a monitoring and debugging tool to capture networking related statistics and prepare them visually in a human friendly way.

More information can be found in the <a href="https://omnetpp.org/doc/inet/api-current/neddoc/index.html" target="_blank">INET Reference</a>.

## Discussion

Use <a href="https://github.com/inet-framework/inet-showcases/issues/??" target="_blank">this page</a>
in the GitHub issue tracker for commenting on this showcase.
