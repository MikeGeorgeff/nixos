{ ... }:
{
  networking = {
    hostName = "addax";
    hostId = "5f297e51";
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    firewall.allowedTCPPorts = [ 22 ];
    interfaces.enp4s0 = {
      useDHCP = false;
      wakeOnLan.enable = true;
      ipv4.addresses = [{
        address = "10.10.3.3";
        prefixLength = 24;
      }];
    };
  };
}
