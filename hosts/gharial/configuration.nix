{ config, pkgs, ... }:
let
  hostname = "gharial";
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
    ../modules/clamav.nix
    ./nfs-mounts.nix
    ./screen.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

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
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
  };

  nix.settings.trusted-users = [ "admin" ];
  nix.settings.trusted-substituters = [ "ssh-ng://nix-ssh@saola.georgeff.co" ];
  nix.settings.trusted-public-keys = [
    "saola.georgeff.co-1:KKcFKKIJSIXUgaLrhKhZqHwVm/qVb2iRKVVNj8d+Ivw="
  ];

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "23.11";
}
