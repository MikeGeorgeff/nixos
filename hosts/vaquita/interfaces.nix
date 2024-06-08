{ ... }:
{
  networking.interfaces = {
    # Open
    enp4s0.useDHCP = false;
    enp5s0.useDHCP = false;

    # WAN
    enp6s0.useDHCP = true;

    # Configure physical interface to act as default for untagged vlans
    enp1s0.ipv4.addresses = [{
      address = "10.10.1.1";
      prefixLength = 24;
    }];

    # Configure physical interface for "lab" network
    enp2s0.ipv4.addresses = [{
      address = "10.10.3.1";
      prefixLength = 24;
    }];

    # Security network
    enp3s0.ipv4.addresses = [{
      address = "10.10.6.1";
      prefixLength = 24;
    }];

    # lan vlan
    lan.ipv4.addresses = [{
      address = "10.10.2.1";
      prefixLength = 24;
    }];

    # iot vlan
    iot.ipv4.addresses = [{
      address = "10.10.4.1";
      prefixLength = 24;
    }];

    # guest vlan
    guest.ipv4.addresses = [{
      address = "10.10.5.1";
      prefixLength = 24;
    }];

    # gaming vlan
    gaming.ipv4.addresses = [{
      address = "10.10.9.1";
      prefixLength = 24;
    }];
  };
}
