{ config, pkgs, ... }:
{
  imports = [
      ./hardware-configuration.nix
      ../modules/openssh.nix
      ../modules/locale.nix
      ../modules/user-admin.nix
      ../modules/user-deploy.nix
      ../modules/tailscale.nix
  ];

  boot = {
    kernel.sysctl = {
      # Enable IPv4 forwarding
      "net.ipv4.conf.all.forwarding" = true;
    };

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    useDHCP = false;
    hostName = "vaquita";
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    firewall.enable = false;

    # vlans
    vlans = {
      lan = {
        id = 20;
        interface = "enp1s0";
      };
      iot = {
        id = 40;
        interface = "enp1s0";
      };
      guest = {
        id = 50;
        interface = "enp1s0";
      };
    };

    # Interfaces
    interfaces = {
      # Unused at the moment
      enp4s0.useDHCP = false;
      enp5s0.useDHCP = false;

      # WAN interface
      enp6s0.useDHCP = true;

      # Configure physical interface to act as default for untagged vlans
      enp1s0 = {
        ipv4.addresses = [{
          address = "10.10.1.1";
          prefixLength = 24;
        }];
      };

      # Configure physical interface for "lab" network
      enp2s0 = {
        ipv4.addresses = [{
          address = "10.10.3.1";
          prefixLength = 24;
        }];
      };

      # Security network
      enp3s0 = {
        ipv4.addresses = [{
          address = "10.10.6.1";
          prefixLength = 24;
        }];
      };

      # lan vlan
      lan = {
        ipv4.addresses = [{
          address = "10.10.2.1";
          prefixLength = 24;
        }];
      };

      # iot vlan
      iot = {
        ipv4.addresses = [{
          address = "10.10.4.1";
          prefixLength = 24;
        }];
      };

      # guest vlan
      guest = {
        ipv4.addresses = [{
          address = "10.10.5.1";
          prefixLength = 24;
        }];
      };
    };

    # NAT
    nat = {
      enable = true;
      externalInterface = "enp6s0";
      internalInterfaces = [ "enp1s0" "enp2s0" "lan" "iot" "guest" "enp3s0" ];
      internalIPs = [ "10.10.1.1/24" "10.10.3.1/24" "10.10.2.1/24" "10.10.4.1/24" "10.10.5.1/24" "10.10.6.1/24" ];
    };

    # Firewall
    nftables = {
      enable = true;
      ruleset = ''
        table ip filter {

          chain output {
            type filter hook output priority 100; policy accept;
          }

          chain input {
            type filter hook input priority filter; policy drop;

            # Allow truested networks to access the router
            iifname { "enp2s0", "lan" } counter accept

            # Allow establised traffic from the wan
            iifname "enp6s0" ct state { established, related } counter accept
            iifname "enp6s0" counter drop
          }

          chain forward {
            type filter hook forward priority filter; policy drop;

            # Allow all networks access to the wan
            iifname { "enp1s0", "enp2s0", "lan", "iot", "guest", "enp3s0" } oifname { "enp6s0" } counter accept
            iifname { "enp6s0" } oifname { "enp1s0", "enp2s0", "lan", "iot", "guest", "enp3s0" } ct state established,related counter accept

            # Allow enp2s0 & lan to access enp1s0
            iifname { "enp2s0", "lan" } oifname { "enp1s0" } counter accept
            iifname { "enp1s0" } oifname { "enp2s0", "lan" } ct state established,related counter accept

            # Allow enp2s0, lan & tailsscale subnet router to access iot
            iifname { "enp2s0", "lan", "tailscale0" } oifname { "iot" } counter accept
            iifname { "iot" } oifname { "enp2s0", "lan", "tailscale0" } ct state established,related counter accept

            # Allow enp2s0 to access lan
            iifname { "enp2s0" } oifname { "lan" } counter accept
            iifname { "lan" } oifname { "enp2s0" } ct state established,related counter accept

            # Allow lan to access enp2s0
            iifname { "lan" } oifname { "enp2s0" } counter accept
            iifname { "enp2s0" } oifname { "lan" } ct state established,related counter accept
          }
        }

        table ip nat {
          chain prerouting {
            type nat hook prerouting priority filter; policy accept;
          }

          # Setup nat  masquerading on the enp6s0 interface
          chain postrouting {
            type nat hook postrouting priority filter; policy accept;
            oifname "enp6s0" masquerade
          }
        }

        # Drop all ipv6 traffic because it is not supported
        table ip6 filter {
          chain input {
            type filter hook input priority 0; policy drop;
          }

          chain forward {
            type filter hook forward priority 0; policy drop;
          }
        }
      '';
    };
  };

  services.kea = {
    dhcp4 = {
      enable = true;

      settings = {
        interfaces-config = {
          interfaces = [ "enp1s0" "enp2s0" "lan" "iot" "guest" "enp3s0" ];
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
            pools = [{ pool = "10.10.1.100 - 10.10.1.199"; }];
            option-data = [
              { name = "routers"; data = "10.10.1.1"; }
            ];
          }
          # lan
          {
            subnet = "10.10.2.0/24";
            pools = [{ pool = "10.10.2.100 - 10.10.2.199"; }];
            option-data = [
              { name = "routers"; data = "10.10.2.1"; }
            ];
          }
          # enp2s0
          {
            subnet = "10.10.3.0/24";
            pools = [{ pool = "10.10.3.100 - 10.10.3.199"; }];
            option-data = [
              { name = "routers"; data = "10.10.3.1"; }
            ];
          }
          # iot
          {
            subnet = "10.10.4.0/24";
            pools = [{ pool = "10.10.4.100 - 10.10.4.199"; }];
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
            pools = [{ pool = "10.10.5.100 - 10.10.5.199"; }];
            option-data = [
              { name = "routers"; data = "10.10.5.1"; }
            ];
          }
          # enp3s0
          {
            subnet = "10.10.6.0/24";
            pools = [{ pool = "10.10.6.100 - 10.10.6.199"; }];
            option-data = [
              { name = "routers"; data = "10.10.6.1"; }
            ];
          }
        ];

      };
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    htop
    ethtool
    tcpdump
    conntrack-tools
  ];

  services.journald = {
    rateLimitBurst = 0;
    extraConfig = "SystemMaxUse=50M";
  };

  security.sudo.wheelNeedsPassword = false;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.05";
}
