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
  - `InterpolatingAntenna`: models any antenna characteristic using linear interpolation

The default antenna module in all radios is `IsotropicAntenna`.

## The model

The showcase contains an example simulation, which consists of four simulation runs, each with a different antenna module type.

The showcase contains an example simulation with four runs, which demonstrates the directional characteristics of four antenna modules. The simulation uses the `AntennaDirectionShowcase` network:

<img class="screen" src="network.png">

The playground size is 400x400 meters.
It contains two `WirelessHost`s, named `source` and `destination`. There is also an `Ipv4NetworkConfigurator`, an `IntegratedVisualizer`, and an `Ieee80211ScalarRadioMedium` module.

The source host is positioned in the center of the playground. The destination host is configured to circle the source host, while the source host pings the destination. We'll record the signal power of the received signal...

the goal is to get the directional characteristic, so the host goes around the other, and send probing transmission from each direction. we record the reception power. the distance stays the same, so its not dependent on that...the host does 1 lap, and in the result, the time maps to degrees.
