:orphan:

Directional Selectivity of Antennas
===================================

Goals
-----

INET contains various directional antenna
models. The support for different antennas is useful for simulating many
kinds of wireless scenarios where antenna characteristics are important.

This showcase aims to highlight the antenna models available in INET,
and their directional characteristics. The showcase contains an example
simulation which demonstrates the direcionality of five antenna models.

| INET version: ``4.0``
| Source files location: `inet/showcases/wireless/directionalselectivity <https://github.com/inet-framework/inet-showcases/tree/master/general/directionalselectivity>`__

Concepts
--------

In INET, radio modules contain transmitter, receiver, and antenna
submodules. The success of receiving a wireless transmission depends on
the strength of the signal present at the receiver, among other things,
such as interference from other signals. Both the transmitter and the
receiver submodules use the antenna submodule of the radio when sending and
receiving transmissions. Actually, the antenna can have its own mobility
submodule, thus its own position and orientation, which also affects
reception.

The antenna module affects transmission and reception in multiple ways:

- The relative position of the transmitting and receiving antennas is used when calculating reception signal strength (i.e. attenuation due to distance).
- Antenna gain is applied to the signal power at transmission and reception. The applied gain depends on each antenna module's directional characteristics, and the relative position and the orientation of the two antennas. This can increase or decrease the received signal power.
- By default, the antenna uses the containing network node's mobility submodule to describe its position and orientation, i.e. it has the same position and orientation as the network node. However, antenna modules have optional mobility submodules of their own.
- All antenna modules have 3D directional characteristics.

INET contains the following antenna module types:

- **Isotropic**:

  - :ned:`IsotropicAntenna`: hypothetical antenna that radiates with the same intensity in all directions
  - :ned:`ConstantGainAntenna`: the same as :ned:`IsotropicAntenna`, but has a constant `gain` parameter (for testing purposes)

- **Omnidirectional**:

  - :ned:`DipoleAntenna`: models a `dipole antenna <https://en.wikipedia.org/wiki/Dipole_antenna>`__

- **Directional**:

  - :ned:`ParabolicAntenna`: models a `parabolic antenna <https://en.wikipedia.org/wiki/Parabolic_antenna>`__'s main radiation lobe, ignoring sidelobes
  - :ned:`CosineAntenna`: models directional antenna characteristics with a cosine pattern

- **Other**:

  - :ned:`InterpolatingAntenna`: can model many complex antenna characteristics using linear interpolation
  - :ned:`AxiallySymmetricAntenna`: models complex antenna characteristics as a rotationally symmetric radiation pattern

The default antenna module in all radios is :ned:`IsotropicAntenna`.

Visualizing antenna directionality
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :ned:`RadioVisualizer` module can visualize antenna directional characteristics,
using its antenna lobe visualization feature. For example, the radiation patterns of
an isotropic and a directional antenna:

.. figure:: antennalobe4.png
   :width: 100%
   :align: center

The visualized lobes indicate the antenna gain. The gain at a given direction is
proportional to the length of the line connecting the node and the boundary of the lobe shape.
This visualization feature can be enabled by setting the visualizer's
:par:`displayAntennaLobes` parameter to ``true`` (false by default).

The visualization is actually a cross-section of the 3D radiation pattern.
By default, the cross-section plane corresponds/is perpendicular to the current
viewing angle, in the global coordinate system. However, one can specify other
planes in the antenna's local coordinate system, using the visualizer's
:par:`antennaLobePlane` parameter. The possible values for the parameter are:
`view` (default), `xy`, `xz`, and `yz`. (The views in the antenna's local
coordinate system are typically useful for validating antenna models,
by checking their shapes from the different viewpoints).

The shape and size of the antenna lobe figure is determined by the characteristics
of the antenna, but also by the parameters of the visualizer. Thus the visualization
is an approximate representation of the antenna's radiation pattern.
Depending on the visualizer's parameters, some fine details of the pattern might be
visible, while others might not.
There are several visualizer parameters for fine-tuning the visualized radiation
pattern.

The antenna lobe figure is made up of circular arcs, the radiuses of which depend
on a base radius, and the gain evaluated at certain angles. The :par:`antennaLobeStep`
parameter specifies how fine-grained the evaluation is, i.e. it evaluates the gain at
every :par:`antennaLobeStep` degrees (10 degrees by default). The size of the arcs at
the intermittent angles are interpolated.

The size of the radiation pattern figure is specified by the :par:`AntennaLobeRadius`
parameter, in pixels (100 by default). It is essentially the base radius, which is
increased or decreased according to the gain. The :par:`AntennaLobeNormalize` parameter
controls whether to display the radiation pattern in a normalized or in an absolute way.
If it's normalized, the maximum gain is displayed at the given antenna lobe radius.
If it's absolute, the 0 dB gain is at the given radius (it's absolute by default).
The normalized version produces figures of the same size for different antennas, useful
for comparing the gain patterns qualitatively. The absolute version produces figures
displayed on the same scale, so the patterns can be compared quantitatively.
The visualizer indicates the 0 dB gain and the maximum gain with dashed circles on the
radiation pattern figure.

The :par:`antennaLobeLogarithmicScale` parameter controls how sensitive the visualization
is to changes in the antenna's gain. If the parameter is set too low, the fine details of
the radiation pattern are not visible (large changes in gain are visualized as small changes
in the lobe shape distance). If it is too high, detail are lost again, as even small changes
from the base radius result in 0 shape distance). There is an optimal range for this value,
depending on the individual antenna characteristics (antennas with little variation need
a higher value in order for the variation to be clearly visible/prominent. similarly,
antennas with high variation need a lower value).

For the description of all parameters of the visualizer, check the NED documentation
of :ned:`RadioVisualizerBase`.

The Model and Results
---------------------

The showcase contains five example simulations, which demonstrate the
directional characteristics of five antenna modules. The simulation uses
the ``DirectionalSelectivityShowcase`` network:

.. figure:: network.png
   :width: 80%
   :align: center

The network contains two :ned:`AdhocHost`\ s, named ``source`` and
``destination``. There is also an :ned:`Ipv4NetworkConfigurator`, an
:ned:`IntegratedVisualizer`, and an :ned:`Ieee80211ScalarRadioMedium` module.

The source host is positioned in the center of the playground. The
destination host is configured to circle the source host, while the
source host pings the destination every 0.5 seconds. We'll use the ping
transmissions to probe the directional characteristics of ``source``'s
antenna, by recording the power of the received signal in
``destination``. The destination host will do one full circle around the
source. The distance of the two hosts will be constant to get meaningful
data about the antenna characteristics. We'll run the simulation with
five antenna types in ``source``: :ned:`IsotropicAntenna`,
:ned:`ParabolicAntenna`, :ned:`DipoleAntenna`, :ned:`CosineAntenna`, and
:ned:`AxiallySymmetricAntenna`. The destination has the default
:ned:`IsotropicAntenna` in all simulations.

The configurations for the five simulations differ in the antenna
settings only, all other settings are in the ``General`` configuration
section:

.. literalinclude:: ../omnetpp.ini
   :start-at: General
   :end-at: displayLink
   :language: ini

The source host is configured to send ping requests every 0.5s. This is
effectively the probe interval, the antenna characteristics data can be
made more fine-grained by setting a more frequent ping rate. The
destination is configured to circle the source with a radius of 150m.
The simulation runs for 360s, and the speed of ``destination`` is set so
it does one full circle. This way, when plotting the reception power,
the time can be directly mapped to the angle.

.. note:: The destination host starts at 90 degrees off the main lobe axis, so the main lobe is more apparent on the reception power plot.

The visualizer is set to display antenna lobes in ``source`` (the
:par:`displayRadios` is the master switch in :ned:`RadioVisualizer`, so it
needs to be set to ``true``), and active data links (indicating successfully received
transmissions).

The antenna specific settings are defined in distinct configurations,
named according to the antenna type used (``IsotropicAntenna``,
``ParabolicAntenna``, ``DipoleAntenna``, ``CosineAntenna``, and
``AxiallySymmetricAntenna``).

Isotropic Antenna
~~~~~~~~~~~~~~~~~

The :ned:`IsotropicAntenna` is the default in all radio modules. This
module models a hypothetical antenna which radiates with the same power
in all directions. It is useful if the emphasis of the simulation is not
on the details of antennas. This module can be used to approximate
real world directionless antennas. The module has no parameters. The
configuration for this antenna is :ned:`IsotropicAntenna` in :download:`omnetpp.ini <../omnetpp.ini>`.
The configuration just sets the antenna type in ``source``:

.. literalinclude:: ../omnetpp.ini
   :start-at: IsotropicAntenna
   :end-before: ParabolicAntenna
   :language: ini

When the simulation is run, it looks like the following:

.. video:: isotropic9.mp4

.. internal video recording, animation speed 1, playback speed 21.88, normal run, zoom 1, crop 25 25 150 50, no dpi scaling

The radiation pattern is a circle, as the antenna is directionless
(actually, the isotropic antenna's radiation pattern is a sphere, which looks like a circle from
any viewpoint). Here is a video of the simulation running:

The destination node circles the source node, all ping messages are
successfully received. Here is the reception power vs. direction:

.. figure:: isotropicchart.png
   :width: 100%

Parabolic Antenna
~~~~~~~~~~~~~~~~~

The :ned:`ParabolicAntenna` module simulates the main lobe radiation
pattern of a `parabolic antenna <https://en.wikipedia.org/wiki/Parabolic_antenna>`__. The antenna module has the following
parameters:

-  :par:`MaxGain`: the maximum gain of the antenna
-  :par:`MinGain`: the minimum gain of the antenna
-  :par:`BeamWidth`: the 3 dB beam width in degrees

The configuration for this antenna is :ned:`ParabolicAntenna` in
:download:`omnetpp.ini <../omnetpp.ini>`:

.. literalinclude:: ../omnetpp.ini
   :start-at: ParabolicAntenna
   :end-before: DipoleAntenna
   :language: ini

When the simulation is run, it looks like the following:

.. video:: parabolic5.mp4

.. <!--internal video recording, animation speed 1, playback speed 21.88, normal run, crop 25 25 150 750-->

The radiation pattern is a narrow lobe. Note that in directions away from
the main direction, the radiation pattern might appear to be zero, but
actually, it is just very small. Note the small protrusion to the left
on the following, zoomed-in image:

.. figure:: parabolicsidelobe.png
   :width: 10%
   :align: center

The ping probe messages are successfully received when the destination
node is near the main lobe of ``source``'s antenna.
Note that the communication can be successful outside the main lobe.
The main lobe just indicates that the antenna gain is larger in that direction,
but the received signal strength can be strong enough elsewhere.
Here is the reception power vs. direction:

.. figure:: parabolicchart.png
   :width: 100%

Dipole Antenna
~~~~~~~~~~~~~~

The :ned:`DipoleAntenna` module models a dipole antenna. It has one
parameter, :par:`length`. The configuration in :download:`omnetpp.ini <../omnetpp.ini>` is the
following:

.. literalinclude:: ../omnetpp.ini
   :start-at: DipoleAntenna
   :end-before: CosineAntenna
   :language: ini

The configuration sets the antenna type to :ned:`DipoleAntenna`, and the
antenna length to 0.1m. The elevation and bank parameters are used to
rotate the source node, so that the radiation pattern is more
interesting (the dipole
radiation pattern's donut shape is the same as the isotropic antenna's
when viewed from above). It looks like this when the simulation is run:

.. video:: dipole5.mp4

.. <!--internal video recording, animation speed 1, playback speed 21.88, normal run, crop 25 25 150 750-->

The radiation pattern is the dipole's donut shape, when viewed from the
side.
There is no successful communication when the destination node is at
the null direction. Here is the reception power vs. direction:

.. figure:: dipolechart.png
   :width: 100%

Cosine Antenna
~~~~~~~~~~~~~~

The :ned:`CosineAntenna` module approximates a directional antenna with a
cosine pattern. In this model, the shape of the radiation pattern is
given by a cosine exponent. The module has two parameters, :par:`maxGain`
and :par:`beamWidth`.

The radiation pattern is similar to the parabolic antenna's. It looks
like the following:

.. video:: cosine4.mp4

Here is the reception power vs. direction:

.. figure:: cosinechart.png
   :width: 100%

Axially Symmetric Antenna
~~~~~~~~~~~~~~~~~~~~~~~~~

The :ned:`AxiallySymmetricAntenna` module can model complex antenna characteristics
with a rotationally symmetrical radiation pattern in 3D. It has three parameters:
the :par:`gains` parameter takes a sequence of gain and angle pairs
(given in decibels and degrees), the first pair must be ``0 0``.
The angle is in the range of (0,180). This describes the gain pattern in a plane.
The characteristics at the intermediate angles are calculated using linear interpolation.
The pattern is then "rotated" by the axis of symmetry to get the radiation pattern in 3D.
The axis of symmetry is given by the :par:`axisOfSymmetry` parameter, ``x`` by default.
There is also a :par:`baseGain` parameter (0 dB by default). The default for the :par:`gains`
parameters is ``"0 0"``, thus by default the antenna models an isotropic antenna.

The configuration for this antenna is :ned:`AxiallySymmetricAntenna` in
:download:`omnetpp.ini <../omnetpp.ini>`:

.. literalinclude:: ../omnetpp.ini
   :start-at: AxiallySymmetricAntenna]
   :end-at: gains
   :language: ini

The antenna type in ``source``'s radio is set to
:ned:`AxiallySymmetricAntenna`. We use the characteristics data from
a real-world 16-element Yagi antenna for the :par:`gains` parameter values.
We also set a :par:`baseGain` of 10 dB, because the gain data is given as relative
(i.e. the maximum gain is at 0 dB). The radiation pattern looks like the following:

.. video:: axiallysymmetric2.mp4

Here is the reception power vs. direction:

.. figure:: axiallysymmetricchart.png
   :width: 100%

Here is the same chart with a logarithmic scale, where the details further from the main lobe are more apparent:

.. figure:: axiallysymmetricchart_log.png
   :width: 100%

Here are the results for all antennas on one chart, for comparison:

.. figure:: allantennaschart.png
      :width: 100%

Sources: :download:`omnetpp.ini <../omnetpp.ini>`, :download:`DirectionalSelectivityShowcase.ned <../DirectionalSelectivityShowcase.ned>`

Discussion
----------

Use `this <https://github.com/inet-framework/inet-showcases/issues/TODO>`__ page in the GitHub issue tracker for commenting on this showcase.
