{ config, ... }:
{
  networking.firewall.allowedTCPPorts = [ 5200 ];

  services.iperf3 = {
    enable = true;
    port = 5200;
  };
}
