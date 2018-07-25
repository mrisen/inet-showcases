---
layout: page
title: Simulating VoIP Applications over the Real Network
hidden: true
---

## Goals

Voice over IP (VoIP) was developed in order to provide access to voice communication in any place around the world. Media streams are transported using special media delivery protocols that encode audio and video with audio codecs, and video codecs. Various codecs exist that optimize the media stream based on application requirements and network bandwidth. INET framework features various modules for emulating different models, including VoIP traffic.

This showcase demonstrates how one can run simulated VoIP applications over real network using INET components.

INET version: `4.0`<br>
Source files location: <a href="https://github.com/inet-framework/inet-showcases/tree/master/emulation/osudpVoip" target="_blank">`inet/showcases/emulation/osudpVoip`</a>

## About VoIP

Voice over Internet Protocol (also voice over IP, VoIP or IP telephony) is a methodology and group of technologies for the delivery of voice communications and multimedia sessions over Internet Protocol (IP) networks, such as the Internet.

VoIP uses codecs to encapsulate audio into data packets, transmit the packets across an IP network and unencapsulate the packets back into audio at the other end of the connection. By eliminating the use of circuit-switched networks for voice, VoIP reduces network infrastructure costs, enables providers to deliver voice services over their broadband and private networks and allows enterprises to operate a single voice and data network.

## The model

The `ExtUdp` module makes it possible for the model to be extracted from the simulation and be used in a real operating environment. The model executes the configured behaviour in the real world while still producing the same statistics as used to.

### The network

Usually a network in a simulation contains some nodes and connections in between. In this case it is different. Only a sender application and a receiver application are needed in order to send the packets into the real network on one side and receive them on the other side.

There are only two modules per "network". There is a `VoipStreamSender` in the sender application and a `VoipStreamReceiver` in the receiver application, both called `app`. Both Applications contain a `ExtUdp` module, called `udp`. The layout of the two applications can be seen on the following image:

| Voip Stream Sender Application || Voip Stream Receiver Application |
| :---: |:---:| :---: |
| <a href="VoipStreamSenderApplication.png" target="_blank"><img class="screen" src="VoipStreamSenderApplication.png"></a> || <a href="VoipStreamReceiverApplication.png" target="_blank"><img class="screen" src="VoipStreamReceiverApplication.png"></a> |

These two simulations work completily separated form each other, meaning that they could also be run on different devices. However, for the sake of simplicity, during this showcase both are run on the same computer. As the names of the applications indicate, the `VoipStreamSenderApplication` produces a VoIP traffic and sends the packets to the `VoipStreamReceiverApplication` as destination, while the `VoipStreamReceiverApplication` receives and processes the VoIP packets.

The simulations are run until all the packets arrive.

### Configuration and behaviour

`VoipStreamSender` and `VoipStreamReceiver` modules are parts of the simulation. There is no difference in the configuration of these modules compared to a fully simulated scenario. This means that the `ExtUdp` module looks and behaves just like the `UdpApp` from the point of view of the modules above them.

**`VoipStreamSender:`**

As stated above, in this showcase both simulations are run on the same computer. That is why the `destAddress` parameter is set to `27.0.0.1` address, called the loopback address, referring to *this computer*.

<p><pre class="snippet">
# Example configuration of the VoipStreamSender module
*.app.packetTimeLength = 20ms
*.app.voipHeaderSize = 4B
*.app.voipSilenceThreshold = 100
*.app.repeatCount = 1

*.app.soundFile = "Beatify_Dabei_cut.mp3"

*.app.localPort = -1
*.app.destPort = 1000
*.app.destAddress = "127.0.0.1"

[Config high_quality]
*.app.codec = "pcm_s16le"
*.app.sampleRate = 32000Hz
</pre></p>

The `high_quality` configuration is run in order to demonstrate that the sound is actually transmitted from the sender to the receiver.

Although the `udp` module does not need any configuration, it is the key module of the emulation. This module acts as a bridge between the simulated and the real world. When instead of `UdpApp` this `ExtUdp` is used, it means that from that point on the emulation is run in the real world. In this case it means that here the VoIP traffic exits the simulation and enters the real operating environment of the OS, and vice versa.

**`VoipStreamReceiver:`**

<p><pre class="snippet">
# Example configuration of the VoipStreamReceiver module
*.app.localPort = 1000
*.app.resultFile = "results/sound.wav"
</pre></p>

Another important point of the emulation is to set the `RealTimeScheduler` as the mean of synchronization:

<p><pre class="snippet">
# Synchronization
scheduler-class = "inet::RealTimeScheduler"
</pre></p>

Using this scheduler, the simulation is run according to the real time of the CPU.

## Results

#### Original music

As a reference, you can listen to the original audio file by clicking on the play button below:

<p><audio controls> <source src="original.mp3" type="audio/mpeg">Your browser does not support the audio tag.</audio></p>

#### `high_quality` configuration

Due to the high sampling rate, the quality of the received sound is nearly as of the original file:

<p><audio controls> <source src="sound.wav" type="audio/wav">Your browser does not support the audio tag.</audio></p>

It is stated above that the two simulations run separately on the same device using the computers loopback interface. To provide some evidence for this statement, we can take a look at the network traffic rate of the interfaces of the computer. It is clearly visible that the traffic rate of the loopback interface (named `lo`) increases from the formerly 0 value to a much higher, relatively constant value. As soon as the sender simulation ends, meaning that there are no more data to be sent, the traffic rate falls back to 0.

<p>
<video autoplay loop controls src="ExtUdp_EDIT.mp4" type="video/mp4" onclick="this.paused ? this.play() : this.pause();">Your browser does not support HTML5 video.</video>
<!--Emulation proof-->
</p>

## Further Information

The following link provides more information about VoIP in general:
- <a href="https://hu.wikipedia.org/wiki/Voice_over_IP" target="_blank">VoIP</a>

The network traffic was observed using <a href="https://github.com/tgraf/bmon" target="_blank">bmon</a>, which is a monitoring and debugging tool to capture networking related statistics and prepare them visually in a human friendly way.

More information can be found in the <a href="https://omnetpp.org/doc/inet/api-current/neddoc/index.html" target="_blank">INET Reference</a>.

## Discussion

Use <a href="https://github.com/inet-framework/inet-showcases/issues/??" target="_blank">this page</a>
in the GitHub issue tracker for commenting on this showcase.
