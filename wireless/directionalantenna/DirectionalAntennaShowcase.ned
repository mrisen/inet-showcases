package inet.showcases.wireless.directionalantenna;

import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.node.inet.WirelessHost;
import inet.physicallayer.ieee80211.packetlevel.Ieee80211ScalarRadioMedium;
import inet.visualizer.integrated.IntegratedVisualizer;


network DirectionalAntennaShowcaseA
{
    @display("bgb=400,400");
    @statistic[receptionPower](source="receptionMinSignalPower(radioMedium.signalArrivalStarted)"; record=vector);
    submodules:
        configurator: Ipv4NetworkConfigurator {
            @display("p=33,43");
        }
        visualizer: IntegratedVisualizer {
            @display("p=34,122");
        }
        radioMedium: Ieee80211ScalarRadioMedium {
            @display("p=34,207");
        }
        source: WirelessHost {
            @display("p=161,193");
        }
        destination: WirelessHost {
            @display("p=339,328");
        }
}
