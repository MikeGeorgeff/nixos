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
    ../modules/qflipper.nix
    ./nfs-mounts.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  services.resolved = {
    enable = true;
    extraConfig = ''
      DNS=45.90.28.0#${hostname}-d76f76.dns.nextdns.io
      DNS=45.90.30.0#${hostname}-d76f76.dns.nextdns.io
      DNSOverTLS=yes
    '';
  };

  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
  };

  users.users.admin = {
    isNormalUser = true;
    description = "Admin";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "dialout" "vboxusers" ];
  };

  services.thinkfan = {
    enable = true;
  };

  nix.settings.trusted-users = [ "admin" ];

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "23.11";
}
