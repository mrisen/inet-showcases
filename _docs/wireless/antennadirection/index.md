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

TODO

This showcase aims to highlight the antenna models available in INET, and their directional characteristics. The showcase contains an example simulation which demonstrates the direcionality of four antenna models.

INET version: `4.0`<br>
Source files location: <a href="https://github.com/inet-framework/inet-showcases/tree/master/general/mobility" target="_blank">`inet/showcases/wireless/antennadirection`</a>

## Concepts

<!-- what is antenna directional selectivity? -->
In reality, the various types of antennas have different characteristics, i.e. they radiate with different power at different directions. NOPE.

In reality, the various antenna types have different characteristics, i.e. they have different radiation patterns / radiate power differently in various directions.

Various antenna types have different directional characteristics. The radiated power might be different, depending on direction.

Various antenna types have different directional characteristics.

<!-- what antenna modules are available in INET? -->
INET has the following antenna models:

- **Isotropic**:
  - `IsotropicAntenna`: hypothetical antenna that radiates with the same intensity in all directions<!-- (no parameters)-->
  - `ConstantGainAntenna`: the same as `IsotropicAntenna`, but has a constant `gain` parameter
- **Omnidirectional**:
  - `DipoleAntenna`: models a dipole antenna<!--, has a `length` parameter-->
- **Directional**:
  - `ParabolicAntenna`: models a parabolic antenna's main radiation lobe<!--, has `minGain`, `maxGain`, and `beamWidth` parameters-->
  - `CosineAntenna`: models directional antenna characteristics with a cosine pattern<!--, has `maxGain` and `beamWidth` parameters-->
- **Other**:
  - `InterpolatingAntenna`: models any antenna characteristic using linear interpolation

shouldnt list all? because they might change? yeah but it is informative

maybe shouldnt list all parameters here ?

The default antenna type in all radio modules is `IsotropicAntenna`



In INET, radio modules contain transmitter, receiver, and antenna submodules. The success of receiving a wireless transmission depends on the strength of the signal present at the receiver, among other things, such as interference from other signals. Both the transmitter and the receiver submodules use the antenna submodules when sending and receiving transmissions. Actually, the antenna can have its own mobility submodule, thus its own position and orientation, which also affects reception.

The antenna module affects transmission and reception in multiple ways. For example:
- Its position and orientation is used when calculating reception signal strength. By default, the antenna uses the containing network node's mobility submodule to describe its position and orientation, i.e. it has the same position and orientation as the network node. However, antenna modules have optional mobility submodules of their own.
- The antenna module type can affect reception and transmission by applying a gain to the transmitted/received signal, depending on the antenna module's directional characteristics.

- the success depends on the signal power at the antenna
- actually, the receiver and transmitter uses the antennas position for receiving
- but the antenna also sets the reception power, depending on the direction and the antenna characteristic

- actually, the

what does the antenna do ? does it apply gain to the signal when trasmitting ? does it apply gain when receiving ? seems so

"Applies a gain to the signal which is taken into account when calculating reception"
