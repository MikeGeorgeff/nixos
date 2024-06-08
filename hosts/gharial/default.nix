{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./dns.nix
    ./networking.nix
    ./nfs-mounts.nix
    ./packages.nix
    ./screen.nix
    ./substituters.nix
    ./user-admin.nix
  ];
}
