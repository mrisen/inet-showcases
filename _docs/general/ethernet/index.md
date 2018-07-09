---
layout: page
title: Ethernet networks
hidden: true
---

## Goals

Ethernet is the most widely installed local area network (LAN) technology. INET features various modules for simulation Ethernet networks using different topologies and technologies. There are also a variety of Ethernet LANs, presented by INET, ranging from the simplest ones, like two hosts directly connected to each other via twisted pair, to more compley ones using mixed connection types and a higher number of hosts.

This showcase presents the `LargeNet` model, which demonstrates how one can put together models of large LANs using different technologies with little effort, and how it can be used for network analysis.

INET version: `3.6.4`<br>
Source files location: <a href="https://github.com/inet-framework/inet-showcases/tree/master/general/ethernet/lans" target="_blank">`inet/showcases/general/ethernet`</a>

## About Ethernet

Ethernet is a family of computer networking technologies commonly used in local area networks (LAN), metropolitan area networks (MAN) and wide are networks (WAN). Systems communicating over Ethernet divide a stream of data into shorte pieces called frames. Each frame contains source and destination addresses, and error-checking data so that damaged frames can be detected and discarded. As per the OSI model, Ethernet provides services up to and including the data link layer.

## About LAN

A local area network (LAN) is a computer network that interconnects computers within a limited area such as a residence, school, laboratory, university campus or office building. By contrast, a wide area network (WAN) not only covers a larger geographic distance, but also generally involves leased telecommunication circuits.
Ethernet and Wi-Fi are the two most common technologies in use for local area networks.

A campus network is a proprietary local area network (LAN) or set of interconnected LANs serving a corporation, government agency, university, or similar organization. The end users in a campus network may be dispersed more widely (in a geographical sense) than in a single LAN, but they are usually not as scattered as they would be in a wide area network (WAN).

## About MAC sublayer

This showcase demonstrates how one can pit together models of large LANs with little effort, making use of MAC auto-configuration.
The medium access comtrol (MAC) sublayer and the logical link control (LLC) sublayer together make up the data link layer. Within the data link layer, the LLC provides flow control and multiplexing for the logical link, while the MAC provides flow control and multiplexing for the transmission medium.

When sending data to another device on the network, the MAN block encapsulates higher-level frames into frames appropriate for transmission medium, adds a frame check sequence to ientify transmission errors, and then forwards the data to the physical layer as soon as the appropriate channel access method permits it. Controlling when data is sent and when to wait is necessary to avoid congestion and collosions, especially for topologies with collosion domains (bus, ring, mesh, point-to-multipoint topologies).Additionally, the MAC is also responsible for cinpensating for congestion and collision by initiating retransmission if a jam signal is detected, and/or negotiating slower transmission rate if necessary. When receiving data from the physical layer, the MAC block ensures data integrity by verifying the sender's frame check sequence, and strips off the sender's preample and padding passing the data up to higher layers.

## The model

The Ethernet model contains a MAC model (`EtherMAC`), LLC model (`EtherLLC`) as well a bus (`EtherBus`, for modelling coaxial cable) and a hub (`EtherHub`) model. A switch model (`EtherSwitch`) is also provided.
- `EtherHost` is a sample node with an Thernet NIC.
- `EtherSwitch`, `EtherBus`, `EtherHub` model switching hub, repeating hub and the coaxial cable.
- basic components of the model: `EtherMAC`, `EtherLLC`/`EtherEncap` module types, `MACRelayUnit`, `EtherFrame` message type, `MACAddress` class.

**Note:** *Nowadays almost all Ethernet networks operate using full-duplex point-to-point connections between hosts and switches. This means that there are no collisions, and the behaviour of the MAC component is much simpler than in classic Ethernet that used coaxial cables and hubs. The INET framework contains two MAC modules for Ethernet: the `EtherMACFullDuplex` is simpler to understand and easier to extend, because it supports only full-duplex connections. The `EtherMAC` module implements the full MAC functionality including CSMA/CD, it can operate both half-duplex and full-duplex mode.*

### The network

`LargeNet` model is a large Ethernet campus backbone. The model mixes all kinds of Ethernet technology: Gigabit Ethernet, 100Mb full duplex, 100Mb half duplex, 10Mb UTP, 10Mb bus, switched hubs and repeating hubs.
There is a chain of "backbone" switches (`switchBB[*]`) as well as large switches (`switchA`, `switchB`, `switchC`, `switchD`). There is one server attached to switches A, B, C and D each: `aerverA`, `serverB`, `serverC` and `serverD`. Then there are several smaller LANs hanging off each backbone switch. There are three types of LANs:
- `SmallLAN:` a small LAN consists of a few computers on a hub (100Mb half duplex).
(<a href="smallLAN_layout.png" target="_blank">SmallLAN layout</a>)
- `MediumLAN:` a medium LAN consists of a smaller switch with a hub on one of its port, and computers on both devices.
(<a href="mediumLAN_layout.png" target="_blank">MediumLAN layout</a>)
- `LargeLAN:` consists of a switch, a hub, and an Ethernet bus connected to one port of the hub.
(<a href="largeLAN_layout.png" target="_blank">LargeLAN layout</a>)

The topology can be seen in the `LargeNet.ned` file:

<a href="LargeNet_layout.png" target="_blank"><img class="screen" src="LargeNet_layout.png"></a>

The application model which generates load on the simulated LAN is simple yet powerful. It can be used as a rough model for any request-response based protocol such as SMB/CIFS (the Windows file sharing protocol), HTTP, or a database client-server protocol. Every computer runs a client application (`EtherAppCli`) which connects to one of the servers, while the servers run `EtherAppSrv`. Clients periodically send a request to the server, and the request packet contains how many bytes the client wants the server to send back.

### Configuration and behaviour

As stated above, this showcase demonstrates how Ethernet LANs using different technologies and devices can easily be connected making use of MAC-autoconfiguration. This means that after setting up the connection in the `LargeNet.ned` file, no complex configuration is needed in the `LargeNet.ini` file:

<p><pre class="snippet">
# MAC settings
**.mac.duplexMode = true
**.switch*.relayUnit.typename = "MacRelayUnit"
</pre></p>

**Note:** *INET framework ethernet switches are built from `IMACRelayUnit` components. Each relay unit has N input and output gates for sending/receiving Ethernet frames.*

The number of switches and LANs and the number of the hosts in each LAN is set in the `largeNet.ini` file by setting the input parameters of the `LargeNet` network:

<p><pre class="snippet">
# example for setting the number of LANs, switches and hosts

LargeNet.n = 8		# number of switches on backbone

LargeNet.*s = 1		# number of LANs of each type on each switch
LargeNet.*m = 1		# number of LANs of each type on each switch
LargeNet.*l = 1		# number of LANs of each type on each switch

LargeNet.*.n = 8	# number of hosts connected to a switch in each LAN
LargeNet.*.h = 5	# number of hosts connected to a hub in each LAN
LargeNet.*.b = 7	# number of hosts connected to a bus in each LAN

#
## number of hosts = SmallLAN.h*(n*bbs+as+bs+cs+ds) + (MediumLAN.h+MediumLAN.n)*(n*bbm+am+bm+cm+dm) + (LargeLAN.h+LargeLAN.n+LargeLAN.b)*(n*bbl+al+bl+cl+dl)
## number of hosts with these settings = 456
#
</pre></p>

For further examination of the model, let's assume that the goal is to design a high performance Ethernet campus area network (CAN). A campus network is a computer network made up of an interconnection of local area networks (LANs) within a limited geigraphical area. In real life, the requirements for performance, capacity and network ports are given in the specification. This example is only concerned about the number of hosts connected to the network and the performance of the LAN. Three different simulations are run:

- `LargeNet_notOverloaded:` Nearly 500 hosts are connected to the network, each performing low data rate. As a result, the network is not overloaded, and no packets are dropped.
- `LargeNet_overloadedBySendIntervall:` Nearly 500 hosts are connected to the network, each performing high data rate. As a result, the network is oveloaded, and packets are dropped.
- `LargeNet_overloadedByNumberOfHosts:` Nearly 7500 hosts are connected to the network, each performing low data rate. As a result, the network is overloaded, and packets are dropped.

The model (especially with the third configuration) generates extensive statistics, so it is recommended to keep both scalar- and vector-recording disabled, and cherry-pick the desired statistics, if necassary, because the generated file could easily reach gigabyte size:

<p><pre class="snippet">
# scalar- and vector-recording disabled
**.result-recording-modes =
**.scalar-recording = false
**.vector-recording = false

# statistics
**.switch*.eth[*].queue.*dropPk*.scalar-recording = true
**.switch*.eth[*].queue.*dropPk*.result-recording-modes = count 
**.mac.*collision*.vector-recording = true
**.mac.*collision*.result-recording-modes = vector
</pre></p>

By default, no finite buffer is used in hosts, so MAC contains an internal queue named `txQueue` to queue up packets waiting for transmission. Conceptually, `txQueue` is of infinite size, but for better diagnostics one can specify a hard limit in the `txQueueuLimit` parameter. If this limit is exceeded, the simulation stops with an error. In this example `DropTailQueue` is used instead, in order to observe the drop statistics (as well):

<p><pre class="snippet">
# queue
**.queue.typename = "DropTailQueue"
**.queue.frameCapacity = 100
</pre></p>

## Results

### LargeNet_notOverloaded

As expected, the 500 hosts, producing an average of 2 request in a second, can not comsume the network's capacity. As the statistic shows, no packets are dropped. That means that the performed traffic is not high enough to oveload the network. This would be a high performance Ethernet local area network with no data-loss and low delay.

It is helpful to examine the `collision` signal, which is an extra signal generated by the `EtherMAC` module. Collision occurs, when a frame is received, while the transmission or reception of another signal is in progress, or when transmission is started, while receiving a frame.

The number of collisions with this configuration is insignificant. As expected, the greatest collision rates are observed in the `largeLAN` models, because these subnetworks contain the highest number of hosts.

### LargeNet_overloadedBySendIntervall

The volume of the traffic can most easily be contorlled with the time period between sending the requests. In this configurations the `sendIntervall` parameter is set to be a specific value of 40ms:

<p><pre class="snippet">
# overloaded configuration example #2
LargeNet.**.cli.reqLength = intuniform(50,1400)*1B
LargeNet.**.cli.respLength = intWithUnit(truncnormal(5000B,5000B))
LargeNet.**.cli.sendInterval = 40ms
</pre></p>

As a result, the generated traffic is about 10 times bigger than it was with the previous configuration. The number of dropped packets increased dramatically. Not surprisingly the most packets are dropped at the connection between the switches `switchBB`, `switchB`, `switchC` and `switchD`, because the majority of the hosts send the packets on this route.

The number of collisions conspicuously increased. This happened, because although the number of hosts on the LANs is the same as it was with the first configuration, the data rate of the hosts is much higher.

If the estimated traffic of the hosts would be as high as it is set in this configuration, then this topology would not fit the requirements, and another topology would need to be chosen.
`
### LargeNet_overloadedByNumberOfHosts

The other way to control the the traffic is to increase or decrease the number of hosts. With this configuration there are nearly 8000 hosts present on the network:

<p><pre class="snippet">
# overloaded configuration example #1
LargeNet.n = 15

LargeNet.bbs=6
LargeNet.bbm=15
LargeNet.bbl=8

LargeNet.?s=4
LargeNet.?m=8
LargeNet.?l=3

LargeNet.*.n = 8
LargeNet.*.h = 5
LargeNet.*.b = 7
</pre></p>

Conceptually the same result is get with the third configuration, as with the second one, meaning an overloaded network. The highest drop rate occours at `switchB.eth[18]`, meaning that the connection between the backbone switches and `switchB` is congested. This is because the number of switches on backbone (`n`) is relatively large number. As a consequence of this, a high traffic is present on that single connection.

As expected, the collision rate is the highest in the largeLANs.
The number of hosts connected to the switch, bus and hub in each configuration is the same, meaning that the number of hosts on a LAN is the same throughout the whole experiment. We can see that the collision rates in the first and the third configuration are within the same order of magnitude. However, the collision rate with the second experiment is with one order of magnitude higher than with the other two. That is because with the second configuration, the same number of hosts on a LAN perform a much hiher traffic, because the sendintervall is less than in the other two configurations.

## Further Information

Useful links:
- <a href="https://en.wikipedia.org/wiki/Local_area_network" target="_blank">LAN</a>
- <a href="https://en.wikipedia.org/wiki/Ethernet" target="_blank">Ethernet</a>
- <a href="https://en.wikipedia.org/wiki/Ethernet_frame" target="_blank">Ethernet frame</a>
- <a href="https://en.wikipedia.org/wiki/Medium_access_control" target="_blank">MAC</a>
- <a href="https://en.wikipedia.org/wiki/Logical_link_control" target="_blank">LLC</a>
- <a href="https://en.wikipedia.org/wiki/Backbone_network" target="_blank">Backbone Network</a>

More information can be found in the <a href="https://omnetpp.org/doc/inet/api-current/neddoc/index.html" target="_blank">INET Reference</a>.

## Discussion

Use <a href="https://github.com/inet-framework/inet-showcases/issues/??" target="_blank">this page</a>
in the GitHub issue tracker for commenting on this showcase.
