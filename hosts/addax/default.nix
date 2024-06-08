{ config, pkgs, ...}:
{
  import = [
    ./hardware-configuration.nix
    ./networking.nix
    ./nfs-server.nix
    ./packages.nix
  ];
}
