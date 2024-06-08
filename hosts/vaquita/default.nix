{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./interfaces.nix
    ./vlans.nix
    ./nat.nix
    ./firewall.nix
    ./dhcp.nix
    ./packages.nix
  ];

  # enable IPv4 Forwarding
  boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;

  networking = {
    useDHCP = false;
    hostName = "vaquita";
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    firewall.enable = false;
  };

  services.journald = {
    rateLimitBurst = 0;
    extraConfig = "SystemMaxUse=50M";
  };
}
