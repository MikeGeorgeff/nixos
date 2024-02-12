{ config, pkgs, ... }:
let
  hostname = "condor";
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

  system.stateVersion = "23.11";
}
