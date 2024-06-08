{ config, pkgs, ... }:
{
  imports = [
    ./harware-configuration.nix
    ./user-admin.nix
    ./networking.nix
    ./nfs-mounts.nix
    ./ssh-serve.nix
  ];
}
