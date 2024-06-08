{ ... }:
{
  services.kea = {
    dhcp4 = {
      enable = true;

      settings = {
        interfaces-config = {
          interfaces = [
            "enp1s0"
            "enp2s0"
            "enp3s0"
            "lan"
            "iot"
            "guest"
            "gaming"
          ];
        };

        lease-database = {
          name = "/var/lib/kea/dhcp4.leases";
          persist = true;
          type = "memfile";
        };

        option-data = [
          { name = "subnet-mask"; data = "255.255.255.0"; }
          { name = "domain-name-servers"; data = "1.1.1.1, 1.0.0.1"; }
        ];

        valid-lifetime = 28800;

        subnet4 = [
          # enp1s0
          {
            subnet = "10.10.1.0/24";

            pools = [
              { pool = "10.10.1.100 - 10.10.1.199"; }
            ];

            option-data = [
              { name = "routers"; "data" = "10.10.1.1"; }
            ];
          }

          # lan
          {
            subnet = "10.10.2.0/24";

            pools = [
              { pool = "10.10.2.100 - 10.10.2.199"; }
            ];

            option-data = [
              { name = "routers"; data = "10.10.2.1"; }
            ];
          }

          # enp2s0
          {
            subnet = "10.10.3.0/24";

            pools = [
              { pool = "10.10.3.100 - 10.10.3.199"; }
            ];

            option-data = [
              { name = "routers"; data = "10.10.3.1"; }
            ];
          }

          # iot
          {
            subnet = "10.10.4.0/24";

            pools = [
              { pool = "10.10.4.100 - 10.10.4.199"; }
            ];

            option-data = [
              { name = "routers"; data = "10.10.4.1"; }
            ];

            reservations = [
              # Ender 3 Printer
              { hw-address = "FC:EE:11:00:D1:D0"; ip-address = "10.10.4.3"; }
              # Hue Bridge
              { hw-address = "EC:B5:FA:0F:44:79"; ip-address = "10.10.4.4"; }
            ];
          }

          # guest
          {
            subnet = "10.10.5.0/24";

            pools = [
              { pool = "10.10.5.100 - 10.10.5.199"; }
            ];

            option-data = [
              { name = "routers"; data = "10.10.5.1"; }
            ];
          }

          # enp3s0
          {
            subnet = "10.10.6.0/24";

            pools = [
              { pool = "10.10.6.100 - 10.10.6.199"; }
            ];

            option-data = [
              { name = "routers"; data = "10.10.6.1"; }
            ];
          }

          # gaming
          {
            subnet = "10.10.9.0/24";

            pools = [
              { pool = "10.10.9.100 - 10.10.9.199"; }
            ];

            option-data = [
              { name = "routers"; data = "10.10.9.1"; }
            ];

            reservations = [
              # PC
              { hw-address = "9C:6B:00:0C:98:FA"; ip-address = "10.10.9.3"; }
              # Steam Deck
              { hw-address = "B0:0C:9D:A5:A0:91"; ip-address = "10.10.9.4"; }
            ];
          }
        ];
      };
    };
  };
}
