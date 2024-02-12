{ config, pkgs, ... }:
let
  hostname = "pangolin";
in
{
  imports = [
    ./hardware-configuration.nix
    ../modules/desktop.nix
    ../modules/openssh.nix
    ../modules/locale.nix
    ../modules/user-deploy.nix
    ../modules/tailscale.nix
    ../modules/nextdns.nix
    ./nfs-mounts.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
  };

  users.users.admin = {
    isNormalUser = true;
    description = "Admin";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  nix.settings.trusted-users = [ "admin" ];

  security.sudo.wheelNeedsPassword = false;

  hardware.system76.enableAll = true;

  system.stateVersion = "23.11";
}
