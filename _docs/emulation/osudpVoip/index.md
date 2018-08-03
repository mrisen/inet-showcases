---
layout: page
title: Simulating VoIP Applications over the Real Network
hidden: true
---

## Goals

Voice over IP (VoIP) was developed in order to provide access to voice communication in any place around the world. Media streams are transported using special media delivery protocols that encode audio and video with audio codecs, and video codecs. INET framework features various modules for emulating different models and scenarios, including VoIP traffic.

This showcase demonstrates how one can run simulated VoIP applications over a real network using INET components.

INET version: `4.0`<br>
Source files location: <a href="https://github.com/inet-framework/inet-showcases/tree/master/emulation/osudpVoip" target="_blank">`inet/showcases/emulation/ExtUdpVoip`</a>

## About VoIP

Voice over Internet Protocol (also voice over IP, VoIP or IP telephony) is a methodology and group of technologies for the delivery of voice communications and multimedia sessions over Internet Protocol (IP) networks, such as the Internet.

VoIP uses codecs to encapsulate audio into data packets, transmit the packets across an IP network and unencapsulate the packets back into audio at the other end of the connection. By eliminating the use of circuit-switched networks for voice, VoIP reduces network infrastructure costs, enables providers to deliver voice services over their broadband and private networks and allows enterprises to operate a single voice and data network.

## The model

The `ExtUdp` module makes it possible for the model to be extracted from the simulation and be used in a real operating environment. The model executes the configured behavior in the real world while still producing the same statistics as used to.

### The network

Usually a network in a simulation contains some nodes and connections in between. In this case it is different. Only a simulated sender application and a simulated receiver application are needed in order to send the packets into the real network on one side and receive them on the other side.

There are only two modules per "network". There is a `VoipStreamSender` in the sender application and a `VoipStreamReceiver` in the receiver application, both called `app`. Both Applications contain a `ExtUdp` module, called `udp`. The layout of the two applications can be seen in the following image:

| Voip Stream Sender Application || Voip Stream Receiver Application |
| :---: |:---:| :---: |
| <a href="VoipStreamSenderApplication.png" target="_blank"><img class="screen" src="VoipStreamSenderApplication.png"></a> || <a href="VoipStreamReceiverApplication.png" target="_blank"><img class="screen" src="VoipStreamReceiverApplication.png"></a> |

These two simulations work completely separated form each other, meaning that they could also be run on different devices. However, for the sake of simplicity, during this showcase both are run on the same computer. As the names of the applications indicate, the `VoipStreamSenderApplication` produces a VoIP traffic and sends the packets to the `VoipStreamReceiverApplication` as destination, while the `VoipStreamReceiverApplication` receives and processes the VoIP packets.

The simulation is run until all the packets arrive.

### Configuration and behaviour

`VoipStreamSender` and `VoipStreamReceiver` modules are part of the simulation. There is no difference in the configuration of these modules compared to a fully simulated scenario. This means that the `ExtUdp` module looks and behaves just like the `UdpApp` from the point of view of the modules above them.

**`VoipStreamSender:`**

As stated above, in this showcase both simulations are run on the same computer. That is why the `destAddress` parameter is set to `27.0.0.1` address, called the loopback address, referring to *this computer*.

<p><pre class="snippet" src="../../emulation/osudpVoip/sender.ini" from="packetTimeLength" comment="#!"></pre></p>

The `VoIP` configuration is run in order to demonstrate that the sound is actually transmitted from the sender to the receiver.

**`VoipStreamReceiver:`**

<p><pre class="snippet" src="../../emulation/osudpVoip/receiver.ini" from="localPort" comment="#!"></pre></p>

Although the `udp` module is the key module of the emulation, it does not need any configuration. This module acts as a bridge between the simulated and the real world. When instead of `UdpApp` this `ExtUdp` is used, it means that from that point on the emulation is running in the real world. In this case it means that at the `ExtUdp` the VoIP traffic exits the simulation and enters the real operating environment of the OS, and vice versa.

Another important point of the emulation is to set the `RealTimeScheduler` as the mean of synchronization:

<p><pre class="snippet" src="../../emulation/osudpVoip/receiver.ini" from="RealTimeScheduler" until="tkenv-plugin-path" comment="#!"></pre></p>

Using this scheduler, the execution of the simulation is synchronized to the real time of the CPU.

**Note:** *Operation of the real-time scheduler: a "base time" is determined when `startRun()` is called. Later on, the scheduler object calls `usleep()` from `getNextEvent()` to synchronize the simulation time to real time, that is, to wait until the current time minus base time becomes equal to the simulation time. Should the simulation lag behind real time, this scheduler will try to catch up by omitting sleep calls altogether.*

## Results

#### Original music

As a reference, you can listen to the original audio file by clicking the play button below:

<p><audio controls> <source src="original.mp3" type="audio/mpeg">Your browser does not support the audio tag.</audio></p>

This music is then sampled and forwarded by the `VoipStreamSender` module and received by the `VoipStreamReceiver` module. The packets exit the simulation at the `ExtUdp` of the sender side and enter the other simulation at the `ExtUdp` of the receiver side. In between the packets travel across the real network (the computer's loopback interface in our case).

#### `VoIP` configuration

Due to the high sampling rate, the quality of the received sound is nearly as good as of the original file:

<p><audio controls> <source src="sound.wav" type="audio/wav">Your browser does not support the audio tag.</audio></p>

It is stated above that the two simulations run separately on the same device using the computer's loopback interface. To provide some evidence for supporting this statement, we can take a look at the network traffic rate of the interfaces of the computer. The following video shows how the traffic rate of the loopback interface (named `lo`) changes while the simulation is running:

<p>
<video autoplay loop controls src="ExtUdp_EDIT.mp4" type="video/mp4" onclick="this.paused ? this.play() : this.pause();">Your browser does not support HTML5 video.</video>
<!--Emulation proof-->
</p>

It is clearly visible that the traffic rate of the loopback interface increases from the former value of zero to a higher, relatively constant value, as soon as the sender side of the emulation is started. After the end of the simulation, meaning that there are no more data to be sent, the traffic rate falls back to zero.

## Conclusion

It is not necessary to rewrite the simulated model into a suitable form for testing it in the real world. Using external interfaces, parts of a simulation can easily be extracted into the real operating environment. This feature of INET makes developing, simulating and testing much simpler.

## Further Information

The following link provides more information about VoIP in general:
- <a href="https://en.wikipedia.org/wiki/Voice_over_IP" target="_blank">VoIP</a>

The network traffic was observed using <a href="https://github.com/tgraf/bmon" target="_blank">bmon</a>, which is a monitoring and debugging tool to capture networking related statistics and prepare them visually in a human friendly way.

More information can be found in the <a href="https://omnetpp.org/doc/inet/api-current/neddoc/index.html" target="_blank">INET Reference</a>.

## Discussion

Use <a href="https://github.com/inet-framework/inet-showcases/issues/??" target="_blank">this page</a>
in the GitHub issue tracker for commenting on this showcase.
