

package inet.showcases.emulation.videostreaming;

import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.node.ethernet.Eth100M;
import inet.node.ethernet.EtherSwitch;
import inet.node.inet.StandardHost;
import inet.visualizer.integrated.IntegratedVisualizer;


network VideoStreamingShowcase
{
    @display("bgb=400,400");
    submodules:
        incomingHost: StandardHost {
            @display("p=64,129;i2=misc/rightdown;i=misc/laptop2");
        }
        outgoingHost: StandardHost {
            @display("p=328,129;i2=misc/rightup;i=misc/laptop2");
        }
        switch: EtherSwitch {
            @display("p=198,239");
        }
        configurator: Ipv4NetworkConfigurator {
            @display("p=51,36");
        }
        visualizer: IntegratedVisualizer {
            @display("p=145,39");
        }
    connections:
        incomingHost.ethg++ <--> Eth100M <--> switch.ethg++;
        switch.ethg++ <--> Eth100M <--> outgoingHost.ethg++;
}

network VideoStreamingShowcaseOneHost
{
    @display("bgb=400,400");
    submodules:
        host: StandardHost {
            @display("p=202,197;i2=misc/rightdown;i=misc/laptop2");
        }
        configurator: Ipv4NetworkConfigurator {
            @display("p=51,36");
        }
        visualizer: IntegratedVisualizer {
            @display("p=145,39");
        }
    connections:
}

network VideoStreamingShowcaseNoSwitch
{
    @display("bgb=400,400");
    submodules:
        incomingHost: StandardHost {
            @display("p=64,129;i2=misc/rightdown;i=misc/laptop2");
        }
        outgoingHost: StandardHost {
            @display("p=328,129;i2=misc/rightup;i=misc/laptop2");
        }
        configurator: Ipv4NetworkConfigurator {
            @display("p=51,36");
        }
        visualizer: IntegratedVisualizer {
            @display("p=145,39");
        }
    connections:
        incomingHost.ethg++ <--> Eth100M <--> outgoingHost.ethg++;
}
