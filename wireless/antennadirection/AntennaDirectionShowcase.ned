package inet.showcases.wireless.antennadirection;

import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.node.inet.WirelessHost;
import inet.physicallayer.ieee80211.packetlevel.Ieee80211ScalarRadioMedium;
import inet.visualizer.integrated.IntegratedVisualizer;


network AntennaDirectionShowcase
{
    @display("bgb=600,400");
    @statistic[receptionPower](source="receptionMinSignalPower(radioMedium.signalArrivalStarted)"; record=vector);
    submodules:
        configurator: Ipv4NetworkConfigurator {
            @display("p=62,43");
        }
        visualizer: IntegratedVisualizer {
            @display("p=62,121");
        }
        radioMedium: Ieee80211ScalarRadioMedium {
            @display("p=62,199");
        }
        source: WirelessHost {
            @display("p=400,200");
        }
        destination: WirelessHost {
            @display("p=400,350");
        }
}
