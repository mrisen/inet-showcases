:orphan:

IEEE 802.11 Infrastructure and Ad Hoc Mode
==========================================

Goals
-----

802.11 devices can commonly operate in two basic modes. In infrastructure mode,
nodes connect to wireless networks created by access points, which
provide services, such as internet access. In ad hoc mode, nodes create
an ad hoc wireless network, without using additional network
infrastructure.

INET has support for simulating both operating modes. This showcase
demonstrates how to configure 802.11 networks in infrastructure and
ad hoc mode, and how to check if they are configured correctly. The
showcase contains two example simulations defined in :download:`omnetpp.ini <../omnetpp.ini>`.

| INET version: ``4.0``
| Source files location: `inet/showcases/wireless/infrastructure <https://github.com/inet-framework/inet-showcases/tree/master/wireless/infrastructure>`__

The Model
---------

A node's operating mode (infrastructure or ad hoc) is determined by the
type of its management module. The management module type can be set
from the ini or NED files, or by choosing one of INET's host types which
have the desired management module by default.

In INET, the management module is a submodule of :ned:`Ieee80211Interface`.
It connects to the MAC module, and it is responsible for handling
management frames, such as beacon frames, probe request and response
frames, and association and authentication frames. The management module
is also responsible for scanning channels and switching between them.
Several types of management modules are available:

- :ned:`Ieee80211MgmtSta`: management module for stations (nodes that join wireless networks) in infrastructure mode
- :ned:`Ieee80211MgmtAp`: management module for access points in infrastructure mode
- :ned:`Ieee80211MgmtAdhoc`: management module for nodes in ad hoc mode

There are also simplified versions of the infrastructure mode management
modules: :ned:`Ieee80211MgmtStaSimplified` and
:ned:`Ieee80211MgmtApSimplified`. They only send and receive data frames,
and they don't simulate the association and authentication process, but
assume that stations are always associated with the access point. They
also cannot simulate handovers.

The agent module (:ned:`Ieee80211AgentSta`) is the submodule of
:ned:`Ieee80211Interface` in devices that act as stations (nodes with
:ned:`Ieee80211MgmtSta` management module types.) It connects to the
management module, and it is responsible for initiating channel
scanning, associations and handovers. It basically simulates user actions, such
as the user instructing the device to connect to a Wifi network. The
topology of connected modules in :ned:`Ieee80211Interface` is displayed on
the following image:

.. figure:: submodules.png
   :width: 70%
   :align: center

Hosts can be configured to use infrastructure or ad hoc mode by
specifying the corresponding management module type. By default,
:ned:`WirelessHost` uses :ned:`Ieee80211MgmtSta`, and :ned:`AccessPoint` uses
:ned:`Ieee80211MgmtAp`. Additionally, :ned:`AdhocHost` is suitable for
simulating ad hoc wireless networks. It is derived from :ned:`WirelessHost`
by changing management module to :ned:`Ieee80211MgmtAdhoc` (and also
turning on IPv4 forwarding.)

In infrastructure mode, the SSID of the network created by an access
point is a parameter of :ned:`Ieee80211MgmtAp`, and it is "SSID" by
default. In stations, the agent module has an SSID parameter, which sets
which network should the node join. When the simulation is run, the
access points automatically create the wireless networks, and agent
modules in station nodes cause the nodes to automatically join the
appropriate network.

The :ned:`Ieee80211MgmtAdhoc` module only sends data frames, and discards
all other frame types like control and management frames. Also, it
doesn't switch channels, just operates on the channel configured in the
radio.

The Configuration
-----------------

The showcase contains two example simulations, with one of them
demonstrating infrastructure mode and the other ad hoc mode (the
configurations in :download:`omnetpp.ini <../omnetpp.ini>` are named ``Infrastructure`` and
``Adhoc``.) Two nodes communicate wirelessly in both of them, the
difference being that in the first case they communicate through an
access point in infrastructure mode, and in the second, directly between
each other in ad hoc mode. The two simulations use similar networks, the
only difference is that there is an access point in the network for the
infrastructure mode configuration. The networks look like the following:

.. figure:: network.png
   :width: 80%
   :align: center

The networks contain two ``WirelessHosts`` named ``host1`` and
``host2``. They also contain an :ned:`Ipv4NetworkConfigurator`, an
:ned:`Ieee80211ScalarRadioMedium` and an :ned:`IntegratedVisualizer` module.
The network for the infrastructure mode configuration also contains an
:ned:`AccessPoint`.

In both simulations, ``host1`` is configured to send UDP packets to
``host2``. :ned:`WirelessHost` has :ned:`Ieee80211MgmtSta` by default, thus no
configuration of the management module is needed in the infrastructure
mode simulation. In the ad hoc mode simulation, the default management
module in hosts is replaced with :ned:`Ieee80211MgmtAdhoc`. The ad hoc management module
doesn't require an agent module, so the agent module type is set to empty string.
(The same effect could have been achieved by using the :ned:`AdhocHost` host type
instead of :ned:`WirelessHost`, as the former has the ad hoc management
module and no agent by default.) The configuration keys for the management module type
in :download:`omnetpp.ini <../omnetpp.ini>` is the following:

.. literalinclude:: ../omnetpp.ini
   :start-at: mgmt
   :end-at: agent
   :language: ini

Note that in the :ned:`AdhocHost` type, forwarding is enabled. However,
forwarding is not required in this simulation, because the hosts can
reach each other in one hop, and packet don't need to be forwarded
(forwarding is required for multihop networks.)

Results
-------

Infrastructure Mode
~~~~~~~~~~~~~~~~~~~

When the infrastructure mode simulation is run, the hosts get associated
with the access point, and ``host1`` starts sending UDP packets to
``host2``. The packets are relayed by the access point. The following
video depicts the UDP traffic:

.. video:: Infrastructure4.mp4
   :width: 698

   <!--internal video recording, animation speed none, zoom 1.3x-->

To verify that the correct management type is configured, go into a
host's wireless interface module. The ``mib`` module (management information base)
displays information about the node's status in the network, e.g. MAC
address, association state, whether or not it's using QoS, etc. It also
displays information about the mode, i.e. infrastructure or ad hoc,
station or access point. The wireless interface module of ``host1`` and
``accessPoint`` is displayed on the following image:

.. figure:: mib_infrastructure.png
   :width: 100%

.. todo::

   <!--
   TODO: this might not be needed because it should be mentioned earlier
   or the earlier image should be cropped to show only the topology
   there should be a screenshot showing the mib in both cases
   and even for the AP and after association for host1
   -->

Ad Hoc Mode
~~~~~~~~~~~

When the ad hoc mode simulation is run, the hosts can communicate
directly with each other. There is no association and authentication,
``host1`` starts to send UDP data at the start of the simulation.
``host1`` is sending UDP packets to ``host2`` in the following video:

.. video:: Adhoc3.mp4
   :width: 698

   <!--internal video recording, animation speed none, zoom 1.3x-->

The wireless interface module of ``host1`` is displayed on the following image,
showing the ``mib`` and the host's network status:

.. figure:: adhocmib.png
   :width: 60%
   :align: center

Sources: :download:`omnetpp.ini <../omnetpp.ini>`, :download:`InfrastructureShowcase.ned <../InfrastructureShowcase.ned>`

Discussion
----------

Use `this <TODO>`__ page in the GitHub issue tracker for commenting on this showcase.
