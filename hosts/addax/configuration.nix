{ config, pkgs, ... }:
let
  hostname = "addax";
in
{
  imports = [
    ./hardware-configuration.nix
    ../modules/locale.nix
    ../modules/openssh.nix
    ../modules/nameservers-default.nix
    ../modules/tailscale.nix
    ../modules/user-admin.nix
    ../modules/user-deploy.nix
    ./nfs-server.nix
    ./nginx.nix
    ./services/gitea.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = true;

  fileSystems."/mnt/vault" = {
    device = "vault";
    fsType = "zfs";
  };

  networking = {
    hostName = "${hostname}";
    hostId = "5f297e51";
    firewall.allowedTCPPorts = [ 22 ];
    defaultGateway.address = "10.10.3.1";
    interfaces.enp4s0 = {
      useDHCP = false;
      wakeOnLan.enable = true;
      ipv4.addresses = [{
        address = "10.10.3.3";
        prefixLength = 24;
      }];
    };
  };

  environment.systemPackages = with pkgs; [
    zfs
    btop
    rsync
  ];

  security.sudo.wheelNeedsPassword = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11";
}
