{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./dns.nix
    ./networking.nix
    ./nfs-mounts.nix
    ./user-admin.nix
  ];

  services.thinkfan.enable = true;
}
