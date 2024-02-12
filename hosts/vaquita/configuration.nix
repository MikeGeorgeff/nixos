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

            # Allow enp2s0 & lan to access iot
            iifname { "enp2s0", "lan" } oifname { "iot" } counter accept
            iifname { "iot" } oifname { "enp2s0", "lan" } ct state established,related counter accept

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

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "enp1s0" "enp2s0" "lan" "iot" "guest" "enp3s0" ];
    machines = [];
    extraConfig = ''
      option subnet-mask 255.255.255.0;

      subnet 10.10.1.0 netmask 255.255.255.0 {
        option domain-name-servers 1.1.1.1, 1.0.0.1;
        option broadcast-address 10.10.1.255;
        option routers 10.10.1.1;
        interface enp1s0;
        range 10.10.1.2 10.10.1.254;
      }

      subnet 10.10.3.0 netmask 255.255.255.0 {
        option domain-name-servers 1.1.1.1, 1.0.0.1;
        option broadcast-address 10.10.3.255;
        option routers 10.10.3.1;
        interface enp2s0;
        range 10.10.3.100 10.10.3.254;
      }

      subnet 10.10.2.0 netmask 255.255.255.0 {
        option broadcast-address 10.10.2.255;
        option routers 10.10.2.1;
        interface lan;
        range 10.10.2.100 10.10.2.254;
      }

      subnet 10.10.4.0 netmask 255.255.255.0 {
        option domain-name-servers 1.1.1.1, 1.0.0.1;
        option broadcast-address 10.10.4.255;
        option routers 10.10.4.1;
        interface iot;
        range 10.10.4.100 10.10.4.254;
      }

      subnet 10.10.5.0 netmask 255.255.255.0 {
        option domain-name-servers 1.1.1.1, 1.0.0.1;
        option broadcast-address 10.10.5.255;
        option routers 10.10.5.1;
        interface guest;
        range 10.10.5.2 10.10.5.254;
      }

      subnet 10.10.6.0 netmask 255.255.255.0 {
        option domain-name-servers 1.1.1.1, 1.0.0.1;
        option broadcast-address 10.10.6.255;
        option routers 10.10.6.1;
        interface enp3s0;
        range 10.10.6.2 10.10.6.254;
      }
    '';
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
