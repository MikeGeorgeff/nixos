{ ... }:
let
  interface = "enp1s0";
in
{
  networking.vlans = {
    lan = {
      id = 20;
      interface = "${interface}";
    };

    iot = {
      id = 40;
      interface = "${interface}";
    };

    guest = {
      id = 50;
      interface = "${interface}";
    };

    gaming = {
      id = 90;
      interface = "${interface}";
    };
  };
}
