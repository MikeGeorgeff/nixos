{ ... }:
{
  networking = {
    hostname = "saola";

    firewall.allowedTCPPorts = [ 22 8080 ];

    extraHosts = ''
      100.81.193.125 gharial
      100.88.169.90  condor
      10.10.3.1      vaquita
      10.10.3.2      saola
      10.10.3.3      addax
    '';

    defaultGateway.address = "10.10.3.1";

    interfaces.enp5s0 = {
      useDHCP = false;

      wakeOnLan.enable = true;

      ipv4.addresses = [{
        address = "10.10.3.2";
        prefixLength = 24;
      }];
    };
  };
}
