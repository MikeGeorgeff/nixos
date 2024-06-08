{ ... }:
{
  networking.nat = {
    enable = true;
    externalInterface = "enp6s0";

    internalInterfaces = [
      "enp1s0"
      "enp2s0"
      "enp3s0"
      "lan"
      "iot"
      "guest"
      "gaming"
    ];

    internalIPs = [
      "10.10.1.1/24"
      "10.10.2.1/24"
      "10.10.3.1/24"
      "10.10.4.1/24"
      "10.10.5.1/24"
      "10.10.6.1/24"
      "10.10.9.1/24"
    ];
  };
}
