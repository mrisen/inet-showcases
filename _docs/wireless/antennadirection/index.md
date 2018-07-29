---
layout: page
title: Directional Selectivity of Antennas
hidden: true
---

TODO: antennas or antennae

keywords: directional characteristics, radiation pattern, directionality, directional selectivity, gain, lobes,

radiation pattern -> depiction of directional characteristics

## Goals

<!-- INET contains several different antenna models -->

INET contains various isotropic, omnidirectional and directional antenna models. The support for different antennas is useful for simulating many kinds of wireless scenarios, as antenna characteristics are important for wireless connectivity.

as wireless connectivity can often depend on antenna characteristics

INET contains various antenna modules, such as the isotropic antenna, which has no directionality, or the high-gain parabolic antenna.

TODO

This showcase aims to highlight the antenna models available in INET, and their directional characteristics. The showcase contains an example simulation which demonstrates the direcionality of four antenna models.

INET version: `4.0`<br>
Source files location: <a href="https://github.com/inet-framework/inet-showcases/tree/master/general/mobility" target="_blank">`inet/showcases/wireless/antennadirection`</a>

## Concepts

In INET, radio modules contain transmitter, receiver, and antenna submodules. The success of receiving a wireless transmission depends on the strength of the signal present at the receiver, among other things, such as interference from other signals. Both the transmitter and the receiver submodules use the antenna submodules when sending and receiving transmissions. Actually, the antenna can have its own mobility submodule, thus its own position and orientation, which also affects reception.

The antenna module affects transmission and reception in multiple ways. For example:
- Its position and orientation is used when calculating reception signal strength. By default, the antenna uses the containing network node's mobility submodule to describe its position and orientation, i.e. it has the same position and orientation as the network node. However, antenna modules have optional mobility submodules of their own.
<!-- - The antenna module type can affect reception and transmission by applying a gain to the transmitted/received signal, depending on the antenna module's directional characteristics. -->
- The antenna applies a gain to the signal, which is taken into account when calculating transmission and reception. The applied gain depends on the antenna module's directional characteristics.

<!-- - the success depends on the signal power at the antenna
- actually, the receiver and transmitter uses the antennas position for receiving
- but the antenna also sets the reception power, depending on the direction and the antenna characteristic -->

<!-- - actually, the

what does the antenna do ? does it apply gain to the signal when trasmitting ? does it apply gain when receiving ? seems so

"Applies a gain to the signal which is taken into account when calculating reception" -->

<!-- INET contains several antenna module types. -->

INET contains the following antenna module types:

- **Isotropic**:
  - `IsotropicAntenna`: hypothetical antenna that radiates with the same intensity in all directions<!-- (no parameters)-->
  - `ConstantGainAntenna`: the same as `IsotropicAntenna`, but has a constant gain parameter
- **Omnidirectional**:
  - `DipoleAntenna`: models a dipole antenna<!--, has a `length` parameter-->
- **Directional**:
  - `ParabolicAntenna`: models a parabolic antenna's main radiation lobe<!--, has `minGain`, `maxGain`, and `beamWidth` parameters-->
  - `CosineAntenna`: models directional antenna characteristics with a cosine pattern<!--, has `maxGain` and `beamWidth` parameters-->
- **Other**:
  - `InterpolatingAntenna`: can model many complex antenna characteristics using linear interpolation

The default antenna module in all radios is `IsotropicAntenna`.

### Visualizing antenna directionality

It is often useful to visualize antenna directional characteristics. The `RadioVisualizer` module can visualize this, using its antenna lobe visualization feature.
The visualizer can display the antenna's radiation pattern, and the antenna lobes, i.e. the directions in which the antenna's gain is stronger. <!--More precisely, it displays the antenna characteristics around antennas as poligonal shape corresponding to the characteristic. -->For example, the radiation patterns of an isotropic and a diretional antenna:

<img class="screen" src="antennalobe2.png">

This visualization feature can be enabled by setting the visualizer's `DisplayAntennaLobes` parameter to `true` (false by default).

TODO about viewing angles

## The model

The showcase contains an example simulation, which consists of four simulation runs, each with a different antenna module type.

The showcase contains five example simulations, which demonstrates the directional characteristics of four antenna modules. The simulation uses the `AntennaDirectionShowcase` network:

<img class="screen" src="network.png">

<!--The playground size is 600x400 meters. <- it doesnt matter-->
The network contains two `AdhocHost`s, named `source` and `destination`. There is also an `Ipv4NetworkConfigurator`, an `IntegratedVisualizer`, and an `Ieee80211ScalarRadioMedium` module.

The source host is positioned in the center of the playground. The destination host is configured to circle the source host, while the source host pings the destination every 0.5 seconds.
We'll use the ping transmissions to probe the directional characteristics of `source`'s antenna, by recording the power of the received signal in `destination`.
The destination host will do one full circle around the source. The distance of the two hosts will be constant to get meaningful data about the antenna characteristics.
We'll run the simulation with five antenna types in `source`: `IsotropicAntenna`, `ParabolicAntenna`, `DipoleAntenna`, `CosineAntenna`, and `InterpolatingAntenna`.
The destination has the default `IsotropicAntenna` in all simulations.

<!-- the goal is to get the directional characteristic, so the host goes around the other, and send probing transmission from each direction. we record the reception power. the distance stays the same, so its not dependent on that...the host does 1 lap, and in the result, the time maps to degrees. -->

The configurations for the five simulations differ in the antenna settings, most of the settings are in the `General` configuration section:

<p><pre class="include" src="omnetpp.ini" from="General" upto="displayLinks"></pre></p>

The source host is configured to send ping requests every 0.5s. This is effectively the probe interval, the antenna characteristic data can be made more fine-grained by setting a more frequent ping rate. The destination is configured to circle the source with a radius of 150m. The simulation runs for 360s, and the speed of `destination` is set so it does one full circle. This way, when plotting the reception power, the time can be directly mapped to the direction angle.

The visualizer is set to display antenna lobes in `source` (the `displayRadios` is the master switch in `RadioVisualizer`, so it needs to be set to `true`), signal arrivals (for the reception power indication), and active data links (indicating successfully received transmissions).

The antenna specific settings are defined in distinct configurations, named according to the antenna type used (`IsotropicAntenna`, `ParabolicAntenna`, `DipoleAntenna`, `CosineAntenna`, and `InterpolatingAntenna`).

### `IsotropicAntenna`

The `IsotropicAntenna` is the default in all radio modules. This module models a hypothetical antenna which radiates with the same power in all directions. It is useful if the emphasis of the simulation is not no on the details of antennas. This module can be used to approximate real world directionless antennas. The module has no parameters.
The configuration for this antenna is `IsotropicAntenna` in omnetpp.ini. The configuration just sets the antenna type in `source`:

<p><pre class="include" src="omnetpp.ini" from="IsotropicAntenna" until="ParabolicAntenna"></pre></p>

When the simulation is run, it looks like the following:

<img class="screen" src="isotropic1.png">

The radiation pattern is a circle, as the antenna is directionless (actually, the isotropic antenna's radiation pattern is a circle from any viewpoint). Here is a video of the simulation running:

<p><video autoplay loop controls onclick="this.paused ? this.play() : this.pause();" src="isotropic3.mp4"></video></p>

The destination node circles the source node, all ping messages are successfully received.

### `ParabolicAntenna`

The `ParabolicAntenna` module simulates the main lobe radiation pattern of a parabolic antenna. The antenna module has the following parameters:

- `MaxGain`: the maximum gain of the antenna
- `MinGain`: the minimum gain of the antenna
- `BeamWidth`: the 3 dB beam width

The configuration for this antenna is `ParabolicAntenna` in omnetpp.ini:

<p><pre class="include" src="omnetpp.ini" from="ParabolicAntenna" until="DipoleAntenna"></pre></p>

When the simulation is run, it looks like the following:

<img class="screen" src="parabolic1.png">

The radiation pattern is a narrow lobe. Note that in directions off from the main direction, the radiation pattern appears zero, but actually, it is just very small. Note that small protrusion to the left on the following, zoomed-in image:

<img class="screen" src="parabolicsidelobe.png">
